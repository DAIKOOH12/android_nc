

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:german_for_u/obj/DT_tuVung.dart';
import 'package:german_for_u/pages/hocTuVung.dart';
import 'package:german_for_u/pages/theGhiNhoTV.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'dart:async';



class CT_TuVung extends StatefulWidget {
  final String maChuDe;
  final String tenChuDe;



  const CT_TuVung({Key? key, required this.maChuDe, required this.tenChuDe})
      : super(key: key);

  @override
  State<CT_TuVung> createState() => _CT_TuVungState();
}

class _CT_TuVungState extends State<CT_TuVung> {
  List<String> _listTuVung = [];
  List<String> _listNghia = [];
  List<String> _listLinkAnh = [];
  List<DT_tuVung> lst = [];
  List<String> listAnhThe = ["images/flashcard.png", 'images/study.png'];
  List<String> listTenThe = ["Thẻ ghi nhớ", "Học"];

  DateTime startTime = DateTime.now();
  FlutterTts flutterTts = FlutterTts();

  int dem = 0;
  String id = "";

  List<String> getListTu() {
    return _listTuVung;
  }

  List<String> getListNghia() {
    return _listNghia;
  }

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
          dem = element['iTuVung'];
          id = element.id;
        });
      });
    }

  }


  void initListCache() {
    for (String i in _listLinkAnh) {
      CachedNetworkImage(
        imageUrl: i,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    speak("");
    getTuVung();
    getDem();
    // initListCache();
    // downloadAndSaveImages(_listLinkAnh);

    // startTime = DateTime.now();
  }


  @override
  void dispose() {
    super.dispose();
    DateTime endTime = DateTime.now();
    Duration timeOpen = endTime!.difference(startTime);
    print('Page opened for: ${timeOpen.inSeconds} seconds');
    upDateTuVung(timeOpen.inSeconds);
    print(lst);
    // super.dispose();
  }

  Future upDateTuVung(int dem2) async {
    try {
      await FirebaseFirestore.instance.collection('tienDo')
          .doc(id)
          .update(
        {
          'iTuVung': dem + dem2
        }
      );
      print(dem+dem2);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getTuVung() async {
    final snapShot = await FirebaseFirestore.instance
        .collection('tuVungTheoCD')
        .where('sMaChuDe', isEqualTo: widget.maChuDe.toString())
        .get();




    if (snapShot.docs.isNotEmpty) {
      snapShot.docs.forEach((value) {

        _listTuVung.add(value['sTu']);
        _listLinkAnh.add(value['sLinkAnh']);
        if(value.data().containsKey('sNghia')) {
          _listNghia.add(value['sNghia']);
          lst.add(DT_tuVung(value['sTu'], value['sNghia'], widget.maChuDe.toString(), widget.tenChuDe.toString(), value['sLinkAnh']));
        }
        // else
        //   {
        //     lst.add(DT_tuVung(value['sTu'], "", widget.maChuDe.toString(), widget.tenChuDe.toString()));
        //   }

      });
    }
    setState(() {
      lst.sort((a ,b ) => a.tu.compareTo(b.tu));
    });

    // downloadAndSaveImages(_listLinkAnh);
  }

  Future<void> speak(String text) async {

    await flutterTts.setLanguage('de-DE');

    await flutterTts.setPitch(0.8);
    await flutterTts.speak(text);
  }

  // Future layNghia() async {
  //   final result = await FirebaseFirestore.instance.collection('tuVungTheoChuDe')
  //       .where('sMaChuDe', isEqualTo: widget.maChuDe)
  //       .get();
  //
  //   if(result.docs.isNotEmpty) {
  //
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // for(String url in _listLinkAnh) {
    //   precacheImage(NetworkImage(url), context);
    // }

    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFE7E4E4FF),
          appBar: AppBar(
            title: Text(widget.tenChuDe),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    width: 300,
                    child: ListView.separated(
                      itemCount: listAnhThe.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10,);
                      },

                      physics: NeverScrollableScrollPhysics(),

                      itemBuilder: (context, index) {
                        return Container(

                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17),
                              color: Colors.white
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              if(index == 0) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return theGhiNhoTV(listTu: getListTu(), listNghia: getListNghia(), listLinkAnh: _listLinkAnh,);
                                    }
                                  )
                                );
                              }
                              else if(index == 1) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      // return hocTuVung(listTu: getListTu(), listNghia: getListNghia(), listLinkAnh: _listLinkAnh,);
                                      return hocTuVung(listTuVung: lst,listTu: getListTu(),);
                                    }
                                  )
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  child: Image(
                                    image: AssetImage(
                                      listAnhThe[index],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 17,),
                                Text(
                                  listTenThe[index],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 30,),

                Container(
                  width: 300,
                  child: ListView.separated(
                    itemCount: _listTuVung.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10,),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return getItemBuilde(context, index);
                      // return Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //       margin: EdgeInsets.only(bottom: 20),
                      //       width: size.width * 0.75,
                      //       height: 100,
                      //       padding: EdgeInsets.all(5),
                      //       decoration: BoxDecoration(
                      //           color: Colors.grey[200],
                      //           borderRadius: BorderRadius.circular(18)),
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         // crossAxisAlignment: CrossAxisAlignment.end,
                      //         children: [
                      //           Text(
                      //             lst[index].tu,
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //                 fontSize: 23, fontWeight: FontWeight.w700),
                      //           ),
                      //
                      //           // SizedBox(height: 20,),
                      //
                      //           if(lst[index].nghia.isNotEmpty)
                      //           Text(
                      //             lst[index].nghia,
                      //             textAlign: TextAlign.center,
                      //           )
                      //
                      //         ],
                      //       ),
                      //     ),
                      //
                      //     SizedBox(width: 10,),
                      //
                      //     GestureDetector(
                      //       onTap: (){
                      //         speak(lst[index].tu.toString());
                      //       },
                      //       child: ImageIcon(
                      //           AssetImage('images/speaker.png')
                      //       ),
                      //     )
                      //
                      //   ],
                      // );
                    },
                  ),
                ),
                SizedBox(height: 15,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getItemBuilde(BuildContext context, int index) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, top: 10, right: 50, bottom: 5),
          width: 290,
          // height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  lst[index].tu,
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  lst[index].nghia,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if(lst[index].linkAnh != "") ...[
                Container(
                  height: 100,
                  // child: CachedNetworkImage(
                  //   imageUrl: lst[index].linkAnh,
                  //   placeholder: (context, url) => CircularProgressIndicator(),
                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                  //
                  // ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.network(lst[index].linkAnh),
                  ),
                )
              ]

            ],
          ),
        ),
        Positioned(

          right: 10,
          top: 0,
          child: IconButton(
            icon: Container(
              width: 20,
              child: Image(
                image: AssetImage('images/speaker.png'),
              ),
            ),
            onPressed: () {
              speak(lst[index].tu);
            },
          ),
        ),
      ]
    );
  }
}