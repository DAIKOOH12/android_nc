import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/pages/CT_NguPhap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../obj/obj_CacBaiNguPhap.dart';

class nguPhap extends StatefulWidget {
  const nguPhap({super.key});

  @override
  State<nguPhap> createState() => _nguPhapState();
}

class _nguPhapState extends State<nguPhap> {

  // List<String> listTenNguPhap = [];
  // List<String> listId = [];
  // List<String> listLink = [];
  List<obj_CacBaiNguPhap> listNP = [];

  @override
  void initState() {
    getListNguPhap();
    super.initState();
  }

  Future getListNguPhap() async {
    final fs_nguPhap = await FirebaseFirestore.instance.collection('CTHT_NguPhap')
        .get();


    if(fs_nguPhap.docs.isNotEmpty) {

      fs_nguPhap.docs.forEach((element) {
        // listTenNguPhap.add(element['sTenChuDe']);
        // listLink.add(element['sLink']);
        // listId.add(element.id);
        // // listLink.add(element['sLink']);
        // // print(element['sTenChuDe']);
        listNP.add(new obj_CacBaiNguPhap(element.id, element['sLink'], element['sTenChuDe']));
      });

    }
    setState(() {
      listNP.sort((a,b) => a.tenChuDe.compareTo(b.tenChuDe));
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(

          children: [
            Center(
              child: Text(
                'Trình độ hiện tại: A1',
                style: TextStyle(
                  fontSize: 24
                ),

              ),
            ),


            Expanded(

              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 25,);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                          return CT_nguPhap(idNguPhap: listNP[index].id,link: listNP[index].link,);
                          }));

                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: size.width * 0.85,
                      height: size.height * 0.13,
                      decoration: BoxDecoration(
                          color: Color(0xFF006A0B),
                          borderRadius: BorderRadius.circular(18)
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.7,
                            height: size.height * 0.13,
                            child: Text(
                              listNP[index].tenChuDe,
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  // backgroundColor: Colors.brown
                              ),
                            ),
                          ),
                        // Stack(
                          //   children: [
                          //     Positioned(
                          //       left: 15,
                          //       top: 10,
                          //       bottom: 0,
                          //       child: Container(
                          //         child: Text(
                          //           listTenNguPhap[index],
                          //           textAlign: TextAlign.center,
                          //           style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 20,
                          //             backgroundColor: Colors.brown
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     // SizedBox(width: 20,),
                          //     Positioned(
                          //       // top: ,
                          //       right: 10,
                          //       top: 0,
                          //       bottom: 0,
                          //       child: CircularPercentIndicator(
                          //         radius: 25,
                          //         lineWidth: 5,
                          //         percent: 0.7,
                          //         progressColor: Color(0xFF0EAD00),
                          //         backgroundColor: Colors.white,
                          //         center: Text('70%', style: TextStyle(color: Colors.white),),
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: listNP.length,
              ),
            ),

          ],
        ),
    );
  }


}
