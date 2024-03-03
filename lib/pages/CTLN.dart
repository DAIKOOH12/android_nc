// import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/obj/obj_DapAnLN.dart';
import 'package:german_for_u/obj/obj_LuyenNghe.dart';

class CTLN extends StatefulWidget {
  final String maBT;
  const CTLN({super.key, required this.maBT});

  @override
  State<CTLN> createState() => _chiTietLuyenNgheState();
}

class _chiTietLuyenNgheState extends State<CTLN> {

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // List<Duration> durations = [];
  // List<Duration> positions = [];
  // List<bool> isPlayingList = [];
  // List<AudioPlayer> audioPlayers = [];

  List<String> lstDapAn = [];
  List<String> listDapAnCX = [];
  bool start = false;
  int scd = 0;


  double sliderMax = 0;

  int ind = 0;

  List<obj_luyenNghe> listBTL = [];

  int dem = 0;
  String id = "";
  DateTime startTime = DateTime.now();

  Future getDem() async {
    var date = DateTime.now();
    var dNgay = date.day.toString() + '/' + date.month.toString() + '/' + date.year.toString();
    print(dNgay);
    final getDem = await FirebaseFirestore.instance.collection('tienDo')
        .where('sEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('dNgay', isEqualTo: dNgay)
        .get();

    if(getDem.docs.isNotEmpty) {
      getDem.docs.forEach((element) {
        setState(() {
          dem = element['iNghe'];
          id = element.id;
        });
      });
    }

  }

  Future updateNghe(int dem2) async {
    try {
      await FirebaseFirestore.instance.collection('tienDo')
          .doc(id)
          .update(
          {
            'iNghe': dem + dem2
          }
      );
      print(dem+dem2);
    } catch (e) {
      print(e.toString());
    }
  }


  Future getBaiTapLuyen() async {
    print(widget.maBT);
    final CTBTL = await FirebaseFirestore.instance.collection('CT_baiTapLuyen')
        .where('sMaBTL', isEqualTo: widget.maBT)
        .get();

    if(CTBTL.docs.isNotEmpty) {

      for(var element in CTBTL.docs) {

        if(!element.data().containsKey('B')){
          continue;
        }

        if(!element.data().containsKey('D') && element.data().containsKey('C')){
          listBTL.add(new obj_luyenNghe(element.id, element['sMaBTL'], element['sLink'], element['sDeBai'], element['sTitle'],
              element['A'], element['B'], element['C'], "", element['sDapAn']));
        }
        else if(!element.data().containsKey('C')){
          listBTL.add(new obj_luyenNghe(element.id, element['sMaBTL'], element['sLink'], element['sDeBai'], element['sTitle'],
              element['A'], element['B'], "", "", element['sDapAn']));
        }
        else if(element.data().containsKey('D')){
          listBTL.add(new obj_luyenNghe(element.id, element['sMaBTL'], element['sLink'], element['sDeBai'], element['sTitle'],
              element['A'], element['B'], element['C'], element['D'], element['sDapAn']));

        }
      }

    }




    final DAD = await FirebaseFirestore.instance.collection('CT_BaiTapNghe')
        .where('sMaBTL', isEqualTo: widget.maBT)
        .get();

    if(DAD.docs.isNotEmpty) {
      DAD.docs.forEach((element) {
        listDapAnCX.add(element['sDapAn']);
      });
    }


    listBTL.sort((a,b) => a.tieuDe.compareTo(b.tieuDe));
    if(mounted) setState(() {
      lstDapAn = List.generate(listBTL.length, (index) => "");
      // isPlayingList = List.generate(listBTL.length, (index) => false);
      // audioPlayers = List.generate(listBTL.length, (index) => AudioPlayer());
      // durations = List.generate(listBTL.length, (index) => Duration.zero);
      // positions = List.generate(listBTL.length, (index) => Duration.zero);
      selectedAnswer = List.generate(listBTL.length, (index) => "");
    });





  }


  @override
  void initState() {


    super.initState();

      getDem();
    Future.delayed(Duration(milliseconds: 1000), () {
      getBaiTapLuyen();
    });


    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
        sliderMax = duration.inSeconds.toDouble();
      });
    });
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });

  }



  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );
  }

  void _showTemporaryDialog(BuildContext context, String text, bool trangThai) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Thông báo'),
          content: Row(
            children: [
              Icon(trangThai ? Icons.check_circle_outlined : Icons.error,
                color: trangThai ? Colors.green : Colors.red,
                size: 40,),
              SizedBox(width: 7,),
              Expanded (
                child: Text(text,

                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  color: trangThai ? Colors.green : Colors.red
                ),),
              ),
            ],
          ),
        );
      },
    );

    // Đóng hộp thoại sau 2 giây
    Future.delayed(Duration(milliseconds: 1500), () {
      // Kiểm tra xem hộp thoại có đang hiển thị không
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Đóng hộp thoại
      }
    });
  }

  void _showKetQua(BuildContext context, String scd, String tong) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bạn đã hoàn thành bài '
                'với kết quả: '+ scd + "/" + tong),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(false),
                  Navigator.of(context).pop(),
                },
                child: Text('OK'),
              ),

            ],
          );

        }

    );
  }



  @override
  void dispose() {
    // for(var player in audioPlayers){
    //   player.dispose();
    // }
    if(!mounted) {
      audioPlayer.stop();
      audioPlayer.dispose();
    }
    DateTime endTime = DateTime.now();
    Duration timeOpen = endTime!.difference(startTime);
    print('Page opened for: ${timeOpen.inSeconds} seconds');
    updateNghe(timeOpen.inSeconds);
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hour = twoDigits(duration.inHours);
    final minute = twoDigits(duration.inMinutes.remainder(60));
    final second = twoDigits(duration.inSeconds.remainder(60));

    return [
      if( duration.inHours > 0) hour, minute, second,

    ].join(':');
  }
  List<String> selectedAnswer = [];



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if(start == true) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Bạn có chắc muốn thoát không?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Không'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Thêm mã để dừng video tại đây
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('Có'),
                        ),
                      ],
                    ),
                  );
                }
                else {
                  Navigator.of(context).pop();
                }
              },
            ),
            centerTitle: true,
            title: Text("Test 1"),
            backgroundColor: Color(0xFF007C1B),
            toolbarHeight: 70,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 26),
                  height: 400,
                  width: size.width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.grey[200]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow),
                                // isPlayingList[ind] ? Icons.pause : Icons.play_arrow),
                            iconSize: 40,
                            onPressed: () async {
                              // print(listBTL.length);
                              // print(lstDapAn[5]);


                              start = true;
                              if (!isPlaying) {
                                // Chạy file mp3 khi container được bấm vào
                                // await audioPlayer.setSourceUrl(url)
                                await audioPlayer.play(UrlSource(listBTL[ind].link));
                                // setAudio(index);
                              } else {
                                // Tạm dừng phát nhạc khi container được bấm vào một lần nữa
                                // await audioPlayer.pause();
                                await audioPlayer.pause();
                              }
                              setState(() {
                                // Đảm bảo chỉ container được bấm vào mới được cập nhật trạng thái chơi nhạc
                                isPlaying = !isPlaying;
                              });

                              // if (isPlaying) {
                              //   await audioPlayer.pause();
                              // } else {
                              //   // String url =
                              //   //     "https://firebasestorage.googleapis.com/v0/b/german-for-u.appspot.com/o/so_dem.mp3?alt=media&token=0605a7ec-4983-465c-9aa0-2e2e238f8c97";
                              //   // Source source = Source.fromString(url);
                              //   // await audioPlayer.setSourceUrl(url);
                              //   await audioPlayer.play(UrlSource(listBTL[index].link));
                              // }
                            },
                          ),
                          Slider(
                            min: 0,
                            max: sliderMax,
                            value: position.inSeconds.toDouble(),
                            thumbColor: Colors.green,
                            onChanged: (value) async {
                              // final positionss =
                              // Duration(seconds: value.toInt());
                              await audioPlayer.seek(
                                  Duration(seconds: value.toInt())
                              );
                              setState(() {
                                position = Duration(seconds: value.toInt());
                              });
                              await audioPlayer.resume();
                            },
                          ),
                          Text(
                            formatTime(duration - position),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: listBTL.isNotEmpty ? Text(listBTL[ind].cauHoi) : SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: listBTL.isNotEmpty ? Text(listBTL[ind].tieuDe) : CircularProgressIndicator(),
                      ),
                      Expanded(
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16.0),
                          children: [
                            if(listBTL.isNotEmpty) ... [
                              RadioListTile<String>(
                                title: listBTL.isNotEmpty ? Text(listBTL[ind].A) : CircularProgressIndicator(),
                                value: 'A',
                                groupValue: selectedAnswer[ind],
                                onChanged: (value) {
                                  setState(() {
                                    selectedAnswer[ind] = value!;
                                  });
                                  lstDapAn[ind] = "A";
                                },

                              ),
                              RadioListTile<String>(
                                title: listBTL.isNotEmpty ? Text(listBTL[ind].B) : CircularProgressIndicator(),
                                value: 'B',
                                groupValue: selectedAnswer[ind],
                                onChanged: (value) {
                                  setState(() {
                                    selectedAnswer[ind] = value!;
                                  });
                                  lstDapAn[ind] = "B";
                                },
                              ),
                              if(listBTL[ind].C != "") ... [
                                RadioListTile<String>(
                                  title: listBTL.isNotEmpty ? Text(listBTL[ind].C) : CircularProgressIndicator(),
                                  value: 'C',
                                  groupValue: selectedAnswer[ind],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswer[ind] = value!;
                                    });
                                    lstDapAn[ind] = "C";
                                  },
                                ),
                              ],
                              if(listBTL[ind].D != "") ... [
                                RadioListTile<String>(
                                  title: listBTL.isNotEmpty ? Text(listBTL[ind].D) : CircularProgressIndicator(),
                                  value: 'D',
                                  groupValue: selectedAnswer[ind],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswer[ind] = value!;
                                    });
                                    lstDapAn[ind] = "D";
                                  },
                                ),
                              ],
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Center(
                  child: MaterialButton(
                    minWidth: 200,
                    height: 60,
                    color: Colors.green,
                    onPressed: () async {

                      // int count = 0;
                      // for (int i=0; i< listBTL.length; i++) {
                      //   if(lstDapAn[i] == listBTL[i].dapAn){
                      //     count ++;
                      //   }
                      // }
                      // print(count);
                      if(lstDapAn[ind] == ""){
                        _showSnackBar(context, "Bạn chưa chọn đáp án");
                      }
                      else {
                        if(lstDapAn[ind] ==listBTL[ind].dapAn){
                          _showTemporaryDialog(context, "Chính xác", true);
                          scd ++;
                        }
                        else {
                          _showTemporaryDialog(context, "Ôi không đáp án đúng là: " + listBTL[ind].dapAn, false);
                          await Future.delayed(Duration(milliseconds: 2200 ));
                        }
                        if(ind<listBTL.length - 1)
                          setState(() {
                            ind ++;
                          });
                        else {
                          _showKetQua(context, scd.toString(), lstDapAn.length.toString() );
                        }
                      }


                    },
                    child: Text("Kiểm tra", style: TextStyle(
                        color: Colors.white70
                    ),),
                  ),
                ),

                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// Material(
//   child: SafeArea(
//     child: Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Test 1"),
//         backgroundColor: Color(0xFF007C1B),
//         toolbarHeight: 70,
//       ),
//       body: Column(
//         children: [
//           Center(
//             child: Container(
//               margin: EdgeInsets.only(top: 26),
//               height: size.height * 0.40,
//               width: size.width*0.85,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.grey[200]
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//
//                       IconButton(
//                         icon: Icon(
//                             isPlaying ? Icons.pause : Icons.play_arrow
//                         ),
//                         iconSize: 40,
//                         onPressed: () async {
//                           if(isPlaying) {
//                             await audioPlayer.pause();
//                           } else {
//                             String url = "https://firebasestorage.googleapis.com/v0/b/german-for-u.appspot.com/o/so_dem.mp3?alt=media&token=0605a7ec-4983-465c-9aa0-2e2e238f8c97";
//                             // Source source = Source.fromString(url);
//                             // await audioPlayer.setSourceUrl(url);
//                             await audioPlayer.play(UrlSource(slink));
//                           }
//                         },
//                       ),
//
//                       Slider(
//                         min: 0,
//                         max: sliderMax,
//                         value: position.inSeconds.toDouble(),
//                         thumbColor: Colors.green,
//
//                         onChanged: (value) async {
//                           final positions = Duration(seconds: value.toInt());
//                           await audioPlayer.seek(positions);
//                           await audioPlayer.resume();
//                         },
//                       ),
//
//                       Text(
//                         formatTime(duration - position),
//                       ),
//
//                     ],
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(question),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(title),
//                   ),
//
//
//                   Expanded(
//                     child: ListView(
//                       padding: EdgeInsets.all(16.0),
//                       children: [
//                         RadioListTile<String>(
//                           title: Text('Answer A'),
//                           value: 'A',
//                           groupValue: selectedAnswer,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedAnswer = value;
//                             });
//                           },
//                         ),
//                         RadioListTile<String>(
//                           title: Text('Answer B'),
//                           value: 'B',
//                           groupValue: selectedAnswer,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedAnswer = value;
//                             });
//                           },
//                         ),
//                         RadioListTile<String>(
//                           title: Text('Answer C'),
//                           value: 'C',
//                           groupValue: selectedAnswer,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedAnswer = value;
//                             });
//                           },
//                         ),
//                         RadioListTile<String>(
//                           title: Text('Answer D'),
//                           value: 'D',
//                           groupValue: selectedAnswer,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedAnswer = value;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//
//
//                 ],
//               ),
//             ),
//           ),
//
//         ],
//       ),
//     ),
//   ),
// );