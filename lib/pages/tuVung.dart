import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/obj/DT_tuVung.dart';
import 'package:german_for_u/pages/CT_TuVung.dart';

class tuVung extends StatefulWidget {
  const tuVung({super.key});

  @override
  State<tuVung> createState() => _tuVungState();
}

class _tuVungState extends State<tuVung> {

  List<String> _listMaChuDe = [], _listTenChuDe = [];


  Future getChuDe() async {
    final snapShot = await FirebaseFirestore.instance.collection('tuVung').get();
    List<String> lmcd = [], ltcd = [], lt = [], ln = [];
    if(snapShot.docs.length > 0) {
      snapShot.docs.forEach((element) {
        lmcd.add(element['sMaChuDe']);
        ltcd.add(element['sTenChuDe']);
        // lt.add(element['sTu']);
        // ln.add(element['sNghia']);
      });
    }
    setState(() {
      _listMaChuDe.addAll(lmcd);
      _listTenChuDe.addAll(ltcd);
      // _li
    });
  }


  @override
  void initState() {
    super.initState();
    getChuDe();

  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [


                // Học từ mới
                Container(
                  padding: EdgeInsets.all(10),
                  width: 160,
                  height: 244,
                  decoration: BoxDecoration(
                    color: Color(0xff0039500),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          child: Column(
                            children: [
                              Icon(Icons.lightbulb_circle, color: Colors.white, size: 40,),
                              SizedBox(height: 100,),
                              Text(
                                  'Học từ mới',
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              Text(
                                '0/10',
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    // fontFamily: 'Itim'
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )
                      )
                    ],
                  ),
                ),

                //Luyện tập
                Container(
                  padding: EdgeInsets.all(10),
                  width: 160,
                  height: 244,
                  decoration: BoxDecoration(
                      color: Color(0xFF77D79D),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          child: Column(
                            children: [
                              ImageIcon(

                                AssetImage('images/education.png'),
                                size: 40,
                                color: Colors.white,
                              ),
                              SizedBox(height: 100,),
                              Text(
                                'Luyện tập',
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              Text(
                                '2/2',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  // fontFamily: 'Itim'
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Các chủ đề từ vựng',
                style: TextStyle(
                  fontSize: 32
                ),
              ),
            ),


            ListView.builder(
              shrinkWrap: true,
              itemCount: _listMaChuDe.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return CT_TuVung(maChuDe: _listMaChuDe[index], tenChuDe: _listTenChuDe[index],);
                      // DT_tuVung tv = DT_tuVung(_tu, _nghia)
                      // return CT_TuVung(DTTV: ,);
                    }));
                  },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 25),
                      padding: EdgeInsets.only(left: 20),
                      width: size.width* 0.85,
                      height: size.height * 0.1,
                      decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9).withOpacity(0.31),
                          borderRadius: BorderRadius.circular(18)
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: ImageIcon(
                                    AssetImage('images/education.png'),
                                    size: 60,
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Container(width: size.width *0.45,child: Text(_listTenChuDe[index])),
                              ],
                            ),
                          ),

                          Positioned(
                            top: 0,
                            right: 10,
                            bottom: 0,
                            child: Icon(Icons.check_circle, color: Colors.green[400], size: 35,),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          ],
        ),
      );
  }
}
