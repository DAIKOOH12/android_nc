import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/pages/CTLN.dart';
import 'package:german_for_u/pages/chiTietLuyenNghe.dart';

class luyenNghe extends StatefulWidget {
  const luyenNghe({super.key});

  @override
  State<luyenNghe> createState() => _luyenNgheState();
}

class _luyenNgheState extends State<luyenNghe> {
  List<String> listBT = [];
  List<String> listId = [];
  late String id;

  Future getBaiLuyen() async {
    final result = await FirebaseFirestore.instance
        .collection('baiTapLuyen')
        .where('sMaKN', isEqualTo: "KN_N")
        .get();

    if (result.docs.isNotEmpty) {
      result.docs.forEach((value) {
        listBT.add(value['sTenBTL']);
        listId.add(value.id);
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getBaiLuyen();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var test;
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Các bài luyện',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF007C1B),
            toolbarHeight: size.height * 0.1,
            // shape: BorderRadius.circular(19),/\
          ),
          body: ListView.builder(
            // separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CTLN(maBT: listId[index]);
                    // return chiTietLuyenNghe(maBT: listId[index],);
                  }));
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        width: size.width * 0.85,
                        height: size.height * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(168, 168, 168, 0.4),
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset: Offset(0, 3),
                            ),
                          ],
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
                                  ImageIcon(AssetImage('images/headphone.png')),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        listBT[index],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        'Luyện nghe bài tập này',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 50),
                                  Text(
                                    '70%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
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
            itemCount: listBT.length,
          ),
        ),
      ),
    );
  }
}
