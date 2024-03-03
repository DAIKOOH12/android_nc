// import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/obj/obj_DapAnLN.dart';
import 'package:german_for_u/obj/obj_LuyenNghe.dart';

class chiTietLuyenNghe extends StatefulWidget {
  final String maBT;
  const chiTietLuyenNghe({super.key, required this.maBT});

  @override
  State<chiTietLuyenNghe> createState() => _chiTietLuyenNgheState();
}

class _chiTietLuyenNgheState extends State<chiTietLuyenNghe> {

  // final audioPlayer = AudioPlayer();
  // bool isPlaying = false;
  // Duration duration = Duration.zero;
  // Duration position = Duration.zero;

  List<Duration> durations = [];
  List<Duration> positions = [];
  List<bool> isPlayingList = [];
  List<AudioPlayer> audioPlayers = [];

  List<String> lstDapAn = [];
  List<String> listDapAnCX = [];


  double sliderMax = 0;

  List<obj_luyenNghe> listBTL = [];


  String question = "";
  String title = "";
  String slink = "";

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
      // CTBTL.docs.forEach((element) {
      //
      //     // question = element['sDeBai'];
      //     // title = element["sTitle"];
      //     // slink = element["sLink"];
      //   if(!element.data().containsKey('D') && element.data().containsKey('C')){
      //     listBTL.add(new obj_luyenNghe(element.id, element['sMaBTL'], element['sLink'], element['sDeBai'], element['sTitle'],
      //         element['A'], element['B'], element['C'], ""));
      //   }
      //   else if(!element.data().containsKey('C')){
      //     listBTL.add(new obj_luyenNghe(element.id, element['sMaBTL'], element['sLink'], element['sDeBai'], element['sTitle'],
      //         element['A'], element['B'], "", ""));
      //   }
      //   else if(element.data().containsKey('D')){
      //     listBTL.add(new obj_luyenNghe(element.id, element['sMaBTL'], element['sLink'], element['sDeBai'], element['sTitle'],
      //         element['A'], element['B'], element['C'], element['D']));
      //
      //   }
      //
      // });
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
      isPlayingList = List.generate(listBTL.length, (index) => false);
      audioPlayers = List.generate(listBTL.length, (index) => AudioPlayer());
      durations = List.generate(listBTL.length, (index) => Duration.zero);
      positions = List.generate(listBTL.length, (index) => Duration.zero);
      selectedAnswer = List.generate(listBTL.length, (index) => "");
    });


    for (int i = 0; i < audioPlayers.length; i++) {
      audioPlayers[i].onPlayerStateChanged.listen((state) {
        if(mounted) {
          setState(() {
            isPlayingList[i] = state == PlayerState.playing;
          });
        }
      });

      audioPlayers[i].onDurationChanged.listen((newDuration) {
        if (mounted) {
          setState(() {
            durations[i] = newDuration;
          });
        }
      });

      audioPlayers[i].onPositionChanged.listen((newPosition) {
        if (mounted) {
          setState(() {
            positions[i] = newPosition;
            sliderMax=newPosition.inSeconds.toDouble();
          });
        }
      });
    }

    // getDapAn(index)

  }


  @override
  void initState() {


    super.initState();
    getBaiTapLuyen();
    getDem();



    // setIsPlayingList();



    // audioPlayer.onPlayerStateChanged.listen((state) {
    //   if(mounted) {
    //     setState(() {
    //       // isPlaying = state == PlayerState.playing;
    //       isPlayingList = List.generate(listBTL.length, (index) => state == PlayerState.playing);
    //     });
    //
    //   }
    //
    // });
    //
    // audioPlayer.onDurationChanged.listen((newDuration) {
    //   if (mounted) {
    //     setState(() {
    //       duration = newDuration;
    //       // print("đây này" + duration.toString());
    //       sliderMax  = newDuration.inSeconds.toDouble();
    //     });
    //   }
    //
    // });
    //
    // audioPlayer.onPositionChanged.listen((newPosition) {
    //   if (mounted) {
    //     setState(() {
    //       position=newPosition;
    //
    //     });
    //   }
    //
    // });
    //
    // setAudio();
  }

  Future setAudio(int index) async {
    // audioPlayer.setReleaseMode(ReleaseMode.loop);
    // String url = "https://firebasestorage.googleapis.com/v0/b/german-for-u.appspot.com/o/so_dem.mp3?alt=media&token=0605a7ec-4983-465c-9aa0-2e2e238f8c97";
    // audioPlayer.setSourceUrl(slink);
    //
    // await audioPlayer.pause();

    audioPlayers[index].setReleaseMode(ReleaseMode.loop);
    audioPlayers[index].setSourceUrl(listBTL[index].link);
    await audioPlayers[index].pause();
  }


  @override
  void dispose() {
    super.dispose();
    for(var player in audioPlayers){
      player.dispose();
    }
    DateTime endTime = DateTime.now();
    Duration timeOpen = endTime!.difference(startTime);
    print('Page opened for: ${timeOpen.inSeconds} seconds');
    updateNghe(timeOpen.inSeconds);
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
            centerTitle: true,
            title: Text("Test 1"),
            backgroundColor: Color(0xFF007C1B),
            toolbarHeight: 70,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
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
                                      isPlayingList[index] ? Icons.pause : Icons.play_arrow),
                                  iconSize: 40,
                                  onPressed: () async {
                                    // print(listBTL.length);
                                    // print(lstDapAn[5]);


                                    setState(() {
                                      // Đảm bảo chỉ container được bấm vào mới được cập nhật trạng thái chơi nhạc
                                      isPlayingList[index] = !isPlayingList[index];
                                    });
                                    if (isPlayingList[index]) {
                                      // Chạy file mp3 khi container được bấm vào
                                      // await audioPlayer.setSourceUrl(url)
                                      await audioPlayers[index].play(UrlSource(listBTL[index].link));
                                      // setAudio(index);
                                    } else {
                                      // Tạm dừng phát nhạc khi container được bấm vào một lần nữa
                                      // await audioPlayer.pause();
                                      await audioPlayers[index].pause();
                                    }

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
                                  max: durations[index].inSeconds.toDouble(),
                                  value: positions[index].inSeconds.toDouble(),
                                  thumbColor: Colors.green,
                                  onChanged: (value) async {
                                    // final positionss =
                                    // Duration(seconds: value.toInt());
                                    await audioPlayers[index].seek(
                                      Duration(seconds: value.toInt())
                                    );
                                    setState(() {
                                      positions[index] = Duration(seconds: value.toInt());
                                    });
                                    await audioPlayers[index].resume();
                                  },
                                ),
                                Text(
                                  formatTime(durations[index] - positions[index]),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(listBTL[index].cauHoi),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(listBTL[index].tieuDe),
                            ),
                            Expanded(
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(16.0),
                                children: [

                                  RadioListTile<String>(
                                    title: Text(listBTL[index].A),
                                    value: 'A',
                                    groupValue: selectedAnswer[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAnswer[index] = value!;
                                      });
                                      lstDapAn[index] = "A";
                                    },

                                  ),
                                  RadioListTile<String>(
                                    title: Text(listBTL[index].B),
                                    value: 'B',
                                    groupValue: selectedAnswer[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAnswer[index] = value!;
                                      });
                                      lstDapAn[index] = "B";
                                    },
                                  ),
                                  if(listBTL[index].C != "") ... [
                                    RadioListTile<String>(
                                      title: Text(listBTL[index].C),
                                      value: 'C',
                                      groupValue: selectedAnswer[index],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedAnswer[index] = value!;
                                        });
                                        lstDapAn[index] = "C";
                                      },
                                    ),
                                  ],
                                  if(listBTL[index].D != "") ... [
                                    RadioListTile<String>(
                                      title: Text(listBTL[index].D),
                                      value: 'D',
                                      groupValue: selectedAnswer[index],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedAnswer[index] = value!;
                                        });
                                        lstDapAn[index] = "D";
                                      },
                                    ),
                                  ],

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: listBTL.length,
                ),

                SizedBox(height: 20,),

                Center(
                  child: MaterialButton(
                    minWidth: 200,
                    height: 60,
                    color: Colors.green,
                    onPressed: () {
                      int count = 0;
                      for (int i=0; i< listBTL.length; i++) {
                        if(lstDapAn[i] == listBTL[i].dapAn){
                          count ++;
                        }
                      }
                      print(count);
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