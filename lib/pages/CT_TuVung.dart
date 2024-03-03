import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:german_for_u/obj/DT_tuVung.dart';


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
  List<DT_tuVung> lst = [];

  DateTime startTime = DateTime.now();
  FlutterTts flutterTts = FlutterTts();

  int dem = 0;
  String id = "";

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

  @override
  void initState() {
    super.initState();
    getTuVung();
    getDem();
    // startTime = DateTime.now();
  }


  @override
  void dispose() {
    super.dispose();
    DateTime endTime = DateTime.now();
    Duration timeOpen = endTime!.difference(startTime);
    print('Page opened for: ${timeOpen.inSeconds} seconds');
    upDateTuVung(timeOpen.inSeconds);
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
        if(value.data().containsKey('sNghia')) {
          _listNghia.add(value['sNghia']);
          lst.add(DT_tuVung(value['sTu'], value['sNghia'], widget.maChuDe.toString(), widget.tenChuDe.toString()));
        }
        else
          {
            lst.add(DT_tuVung(value['sTu'], "", widget.maChuDe.toString(), widget.tenChuDe.toString()));
          }

      });
    }
    setState(() {
      lst.sort((a ,b ) => a.tu.compareTo(b.tu));
    });
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

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.tenChuDe),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  itemCount: _listTuVung.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          width: size.width * 0.75,
                          height: 100,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(18)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                lst[index].tu,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.w700),
                              ),

                              // SizedBox(height: 20,),

                              if(lst[index].nghia.isNotEmpty)
                              Text(
                                lst[index].nghia,
                                textAlign: TextAlign.center,
                              )

                            ],
                          ),
                        ),

                        SizedBox(width: 10,),

                        GestureDetector(
                          onTap: (){
                            speak(lst[index].tu.toString());
                          },
                          child: ImageIcon(
                              AssetImage('images/speaker.png')
                          ),
                        )

                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}