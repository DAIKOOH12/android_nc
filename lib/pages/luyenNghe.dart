import 'package:flutter/material.dart';
import 'package:german_for_u/pages/chiTietLuyenNghe.dart';

class luyenNghe extends StatefulWidget {
  const luyenNghe({super.key});

  @override
  State<luyenNghe> createState() => _luyenNgheState();
}

class _luyenNgheState extends State<luyenNghe> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var test;
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Các bài luyện'),
            centerTitle: true,
            backgroundColor: Color(0xFF007C1B),
            toolbarHeight: size.height * 0.1,
            // shape: BorderRadius.circular(19),/\
          ),

          body: ListView.builder(
            // separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push (
                      context,
                      MaterialPageRoute(builder: (context) {
                        return chiTietLuyenNghe();
                      }));
                },

                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Center(
                      child: Container(
                        width: size.width * 0.85,
                        height: size.height* 0.1,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.grey[200],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 10,
                              bottom: 0,
                              child: Row(
                                children: [
                                  ImageIcon(
                                      AssetImage('images/headphone.png')
                                  ),

                                  SizedBox(width: 20),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'TEST ' + (index + 1).toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),

                                      Text(
                                        'Luyện nghe bài tập này',
                                        style: TextStyle(
                                            fontSize: 13
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(width: 50),
                                  Text(
                                    '70%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15
                                    ),
                                  )

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              );
            },
            itemCount: 20,),
        ),

      ),
    );
  }
}


// body: Column(
//     SizedBox(height: 30,),
//     Center(
//       child: Container(
//         width: size.width * 0.85,
//         height: size.height* 0.1,
//
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(18),
//           color: Colors.grey[200],
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: 0,
//               left: 10,
//               bottom: 0,
//               child: Row(
//                 children: [
//                   ImageIcon(
//                     AssetImage('images/headphone.png')
//                   ),
//
//                   SizedBox(width: 20),
//
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'TEST 1',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700
//                         ),
//                       ),
//
//                       Text(
//                         'Luyện nghe bài tập này',
//                         style: TextStyle(
//                             fontSize: 13
//                         ),
//                       ),
//
//                     ],
//                   ),
//                   SizedBox(width: 50),
//                   Text(
//                     '70%',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 15
//                     ),
//                   )
//
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     )
//   ],
// ),