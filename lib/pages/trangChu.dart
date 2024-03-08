import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:german_for_u/pages/AIChat.dart';
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
  String name = "default";

  List<String> items = ["Từ vựng", "Ngữ pháp", "Luyện thi"];
  int current = 0;

  Future<String> getName() async {
    final user = await FirebaseAuth.instance.currentUser!;
    // print("'" + user.email.toString() + "'");

    final userSnapshot = await FirebaseFirestore.instance
        .collection("user")
        .doc(user.email.toString())
        .get();

    if (userSnapshot.exists) {
      print(userSnapshot.get('hoTen'));
      return userSnapshot.get('hoTen').toString();
    } else
      return "lỗi";
  }

  Future createTienDo() async {
    DateTime today = DateTime.now();
    final getTienDo = await FirebaseFirestore.instance
        .collection('tienDo')
        .where('sEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where('dNgay',
            isEqualTo: today.day.toString() +
                "/" +
                today.month.toString() +
                "/" +
                today.year.toString())
        .get();

    if (getTienDo.docs.isNotEmpty) {
      print("Đã có");
    } else {
      print("kkkk");
      try {
        await FirebaseFirestore.instance.collection('tienDo').add({
          'sEmail': FirebaseAuth.instance.currentUser?.email,
          'dNgay': today.day.toString() +
              "/" +
              today.month.toString() +
              "/" +
              today.year.toString(),
          'iTuVung': 0,
          'iNghe': 0,
          'iNguPhap': 0,
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    createTienDo();
    getName().then((value) => setState(() {
          name = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Hallo ' + name,
                style: TextStyle(color: Color(0xFF038400)),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return taiKhoan();
                      }));
                    },
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                DefaultTabController(
                  length: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                    border: Border.all(
                                        color: Color(0xff026B00), width: 1),
                                    borderRadius: BorderRadius.circular(30),
                                    // color: Colors.grey[100]
                                  ),
                                  height: 60,
                                  width: 150,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Từ vựng',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                  child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xff026B00), width: 1),
                                    borderRadius: BorderRadius.circular(30)),
                                height: 60,
                                width: 150,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Ngữ pháp',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              )),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xff026B00), width: 1),
                                      borderRadius: BorderRadius.circular(30)),
                                  height: 60,
                                  width: 150,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Luyện thi',
                                      style: TextStyle(fontSize: 17),
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
                      ),
                    ],
                  ),
                ),
                Positioned(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (context)=>Home())
                        );
                      },
                      child: Container(
                          child: Image(
                              image: AssetImage(
                                  'images/ai_chatbot_icon.png'),
                          ),
                        width: 30.0,
                        height: 30.0,
                      ),
                      backgroundColor: Color.fromRGBO(0, 132, 157, 1.0),
                    ),
                  ),
                ))
              ],
            )));
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
