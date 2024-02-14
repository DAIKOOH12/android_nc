import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/pages/lu%E1%BB%B5enThi.dart';
import 'package:german_for_u/pages/nguPhap.dart';
import 'package:german_for_u/pages/taiKhoan.dart';
import 'package:german_for_u/pages/tuVung.dart';
import 'package:google_sign_in/google_sign_in.dart';

class trangChu extends StatefulWidget {
  const trangChu({super.key});

  @override
  State<trangChu> createState() => _trangChuState();
}

class _trangChuState extends State<trangChu> {
  List<String> items = ["Từ vựng","Ngữ pháp","Luyện thi"];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    late TabController tabController;
    final user = FirebaseAuth.instance.currentUser!;
    final hehh = user.uid;
    // print(hehh);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(

              title: Text('Hallo ' + user.displayName.toString(), style: TextStyle(color: Color(0xFF038400)),),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return taiKhoan();
                          }
                        )
                      );
                    },
                    child: Icon(
                        Icons.account_circle_rounded,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
            body: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  Material(
                    child: Container(
                      height: 60,
                      
                      child: TabBar(

                        labelColor: Colors.white,
                        // indicatorPadding: EdgeInsets.all(10),
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.all(10),
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xff026B00),

                        ),
                        tabs: [
                          Tab(
                            child: Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff026B00), width: 1),
                                borderRadius: BorderRadius.circular(30),
                                // color: Colors.grey[100]
                              ),
                              height: 60,
                              width: 150,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Từ vựng',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xff026B00), width: 1),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              height: 60,
                              width: 150,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Ngữ pháp',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),
                              ),
                            ),
                          )
                          ),

                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xff026B00), width: 1),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              height: 60,
                              width: 150,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Luyện thi',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),
                              ),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      tuVung(),
                      nguPhap(),
                      luyenThi(),
                    ]),
                  )
                ],
              ),
            )
        )
    );
  }
}

// body: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text('hehehehe'),
// MaterialButton(
// onPressed: () async {
// await FirebaseAuth.instance.signOut();
// await GoogleSignIn().signOut();
// },
// child: Text('sign out'),
// color: Colors.purple,
// )
// ],
// )),


// color: Colors.yellow,
// child: ListView.builder(
//
//   scrollDirection: Axis.horizontal,
//   itemCount: tabLayout.length,
//   physics: const BouncingScrollPhysics(),
//
//   itemBuilder: (context, index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           current = index;
//         });
//       },
//       child: Padding(
//         padding: EdgeInsets.only(top: 5, left: 13),
//           child: Text(
//               tabLayout[index],
//             style: TextStyle(
//               fontWeight: current == index? FontWeight.w400 : FontWeight.w300,
//             ),
//           )
//       ),
//     );
//
//   },
//
// ),