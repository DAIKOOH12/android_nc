import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_learning/Models/TestFormModels.dart';
import 'package:english_learning/Models/Users_ThiNgheModels.dart';
import 'package:english_learning/Pages/CT_Listening.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ResultForm.dart';

class ListeningTestform extends StatefulWidget {
  String? made;
  String? url_audio;

  ListeningTestform({this.made, this.url_audio});

  @override
  State<StatefulWidget> createState() => _ListeningTestform();
}

class _ListeningTestform extends State<ListeningTestform> {
  bool isLoading = false;
  int tongdiem = 0;
  String? getMaDe;
  List<TestFormModels> lstTest = [];
  var index = 0;
  late String? user = '';
  @override
  String warningText = '';
  int selectedOption = 0;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  void initState() {
    _loadData();
    loadUser();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    super.initState();
  }

  Future<void> loadUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user = pref.getString('auth_token');
    });
  }

  Future _loadData() async {
    getMaDe = widget.made;
    final cauTheoMaDe = await FirebaseFirestore.instance
        .collection('CT_ThiNghe')
        .where('made', isEqualTo: getMaDe!)
        .get();
    if (cauTheoMaDe.docs.isNotEmpty) {
      cauTheoMaDe.docs.forEach((element) {
        lstTest.add(new TestFormModels(
            made: element['made'],
            question: element['question'],
            A: element['A'],
            B: element['B'],
            C: element['C'],
            D: element['D'],
            awnser: element['awnser']));
      });
    }
    setState(() {});
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  Future _updateDiem(
      String? user, String made, String diem, String solanlam) async {
    final idTest = user.toString() + '_' + made;
    final userTest = await FirebaseFirestore.instance
        .collection('Users_ThiNghe')
        .where('id', isEqualTo: idTest)
        .get();
    print(idTest);
    if (userTest.docs.isNotEmpty) {
      Users_ThiNgheModels newUpdateTest = Users_ThiNgheModels(
          id: idTest, diem: diem, solanlam: solanlam, email: user.toString());
      _updateResult(newUpdateTest, idTest);
    } else {
      Users_ThiNgheModels newTest = Users_ThiNgheModels(
          id: idTest, diem: diem, solanlam: solanlam, email: user.toString());
      _createResult(newTest, idTest);
    }
  }

  void _updateResult(Users_ThiNgheModels users_thiNgheModels, String idTest) {
    final testCollection =
        FirebaseFirestore.instance.collection('Users_ThiNghe');

    String id = idTest;

    final newTest = Users_ThiNgheModels(
            id: users_thiNgheModels.id,
            diem: users_thiNgheModels.diem,
            solanlam: users_thiNgheModels.solanlam,
            email: users_thiNgheModels.email)
        .toJSON();

    testCollection.doc(id).update(newTest);
  }

  void _createResult(Users_ThiNgheModels users_thiNgheModels, String idTest) {
    final testCollection =
        FirebaseFirestore.instance.collection('Users_ThiNghe');

    String id = idTest;

    final newTest = Users_ThiNgheModels(
            id: users_thiNgheModels.id,
            diem: users_thiNgheModels.diem,
            solanlam: users_thiNgheModels.solanlam,
            email: users_thiNgheModels.email)
        .toJSON();

    testCollection.doc(id).set(newTest);
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('GOOD LUCK!'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {}),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(position)),
                            Text(formatTime(duration - position)),
                          ],
                        ),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer
                                .play(UrlSource(widget.url_audio!));
                          }
                        },
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      ),
                      Text(
                        lstTest.length == 0
                            ? 'Đang tải'
                            : lstTest[index].question,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      ListTile(
                        title: Text(lstTest.length == 0
                            ? 'Đang tải'
                            : lstTest[index].A),
                        leading: Radio<int>(
                          value: 1,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                              print("Button value: $value");
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(lstTest.length == 0
                            ? 'Đang tải'
                            : lstTest[index].B),
                        leading: Radio<int>(
                          value: 2,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                              print("Button value: $value");
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(lstTest.length == 0
                            ? 'Đang tải'
                            : lstTest[index].C),
                        leading: Radio<int>(
                          value: 3,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                              print("Button value: $value");
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(lstTest.length == 0
                            ? 'Đang tải'
                            : lstTest[index].D),
                        leading: Radio<int>(
                          value: 4,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                              print("Button value: $value");
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(warningText),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (selectedOption == 0) {
                              setState(() {
                                warningText = 'Hãy chọn 1 câu trả lời nhé!';
                              });
                            } else {
                              setState(() {
                                print('Bạn chọn $selectedOption');
                                print(lstTest[index].awnser);

                                if (selectedOption ==
                                    int.parse(lstTest[index].awnser)) {
                                  setState(() {
                                    warningText =
                                        'Bạn đã trả lời đúng! Chúc mừng!';
                                    tongdiem++;
                                  });
                                  Future.delayed(Duration(milliseconds: 900),
                                      () {
                                    setState(() {
                                      if (index == lstTest.length - 1) {
                                        String? made = this.getMaDe;
                                        String user = this.user!;

                                        _updateDiem(user, made!,
                                            tongdiem.toString(), 1.toString());
                                        setState(() {
                                          isLoading = true;
                                        });
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResultForm(
                                                          total: lstTest.length,
                                                          result: tongdiem)),
                                              (route) => false);
                                        });
                                      } else {
                                        index++;
                                      }
                                      selectedOption = 0;
                                      warningText = '';
                                    });
                                  });
                                } else {
                                  setState(() {
                                    warningText = 'Bạn đã trả lời sai! :<';
                                  });
                                  Future.delayed(Duration(milliseconds: 900),
                                      () {
                                    setState(() {
                                      if (index == lstTest.length - 1) {
                                        String? made = this.getMaDe;
                                        String user = this.user!;

                                        _updateDiem(user, made!,
                                            tongdiem.toString(), 1.toString());
                                        setState(() {
                                          isLoading = true;
                                        });
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResultForm(
                                                          total: lstTest.length,
                                                          result: tongdiem)),
                                              (route) => false);
                                        });
                                      } else {
                                        index++;
                                      }
                                      selectedOption = 0;
                                      warningText = '';
                                    });
                                  });
                                }
                              });
                            }
                          },
                          child: Text('Kiểm tra'))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
