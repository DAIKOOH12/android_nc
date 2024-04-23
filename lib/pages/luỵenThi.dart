import 'package:flutter/material.dart';
import 'package:german_for_u/pages/luyenNghe.dart';

class luyenThi extends StatefulWidget {
  const luyenThi({super.key});

  @override
  State<luyenThi> createState() => _luyenThiState();
}

class _luyenThiState extends State<luyenThi> {
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Material(
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
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
              
                    SizedBox(height: 25,),
              
                    //luyện nghe
                    // GestureDetector(
                    //   onTap: (){
                    //     Navigator.push(context, MaterialPageRoute(builder: (context){
                    //       return luyenNghe();
                    //     }));
                    //   },
                    //   child: Container(
                    //     width: size.width * 0.85,
                    //     height: size.height * 0.2,
                    //     decoration: BoxDecoration(
                    //       color: Color(0xFFD7FFDB),
                    //       borderRadius: BorderRadius.circular(18),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Color.fromRGBO(168, 168, 168, 0.4),
                    //           spreadRadius: 2,
                    //           blurRadius: 1,
                    //           offset: Offset(0, 3),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Stack(
                    //       children: [
                    //         // Text(
                    //         //     "Horen",
                    //         //   style: TextStyle(
                    //         //     fontSize: 30,
                    //         //   ),
                    //         // ),
                    //         // Positioned(
                    //         //
                    //         //   child: Container(
                    //         //     padding: EdgeInsets.all(20),
                    //         //       decoration: BoxDecoration(
                    //         //         // color: Colors.white
                    //         //         borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))
                    //         //       ),
                    //         //       child: Row(
                    //         //         children: [
                    //         //           // Image(image: AssetImage('images/headphone.png'),
                    //         //           //
                    //         //           //   // AssetImage('images/headphone.png'),
                    //         //           //   // size: 50,
                    //         //           // ),
                    //         //           // SizedBox(width: 10,),
                    //         //           // Expanded(
                    //         //           //   child: Wrap(
                    //         //           //     children: [
                    //         //           //       Text(
                    //         //           //         'Luyện thi bài nghe theo chứng chỉ',
                    //         //           //         style: TextStyle(
                    //         //           //           fontSize: 20,
                    //         //           //         ),
                    //         //           //       ),
                    //         //           //     ]
                    //         //           //   ),
                    //         //           // )
                    //         //         ]
                    //         //       )
                    //         //   ),
                    //         // )
                    //       ],
                    //     ),
                    //   ),
                    // ),
              
                    SizedBox(height: 30,),
              
                    //Bài đọc
              
                    // Container(
                    //   width: size.width * 0.85,
                    //   height: size.height * 0.2,
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFFD7FFDB),
                    //     borderRadius: BorderRadius.circular(18),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Color.fromRGBO(168, 168, 168, 0.4),
                    //         spreadRadius: 2,
                    //         blurRadius: 1,
                    //         offset: Offset(0, 3),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Stack(
                    //     children: [
                    //
                    //       Text(
                    //           "Prüfungsvorbereitung",
                    //         style: TextStyle(
                    //           fontSize: 30
                    //         ),
                    //       ),
                    //       Positioned(
                    //         bottom: 0,
                    //         left: 0,
                    //         right: 0,
                    //         child: Container(
                    //             padding: EdgeInsets.all(20),
                    //             height: size.height * 0.13,
                    //             decoration: BoxDecoration(
                    //               // color: Colors.white
                    //                 borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))
                    //             ),
                    //             child: Row(
                    //                 children: [
                    //                   Image(image: AssetImage('images/reading.png'),
                    //
                    //                     // AssetImage('images/headphone.png'),
                    //                     // size: 50,
                    //                   ),
                    //                   SizedBox(width: 10,),
                    //                   Expanded(
                    //                     child: Wrap(
                    //                         children: [
                    //                           Text(
                    //                             'Luyện thi bài đọc theo chứng chỉ',
                    //                             style: TextStyle(
                    //
                    //                             ),
                    //                           ),
                    //                         ]
                    //                     ),
                    //                   )
                    //                 ]
                    //             )
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )

                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
