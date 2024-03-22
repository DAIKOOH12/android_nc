import 'package:english_learning/Pages/CT_TuVung.dart';
import 'package:english_learning/Pages/LuyenThiSkills.dart';
import 'package:english_learning/Pages/NguPhap.dart';
import 'package:english_learning/Pages/SettingPage.dart';
import 'package:english_learning/Pages/TodayLesson.dart';
import 'package:english_learning/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=>SettingPage())
            );
          }, icon: Icon(Icons.settings))
        ],
      ),
      body: Center(
          child: ListView(
              addAutomaticKeepAlives: false,
              cacheExtent: 100.0,
              physics: AlwaysScrollableScrollPhysics(),
              children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/images/home_logo.png')),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context)=>TodayLesson())
                      );
                    },
                    child: Text(
                      "Bài học hôm nay",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        elevation: 4,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                      CupertinoPageRoute(builder: (context)=>CT_TungVung())
                      );
                    },
                    child: Text(
                      "Từ vựng",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        elevation: 4,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>NguPhap())
                      );
                    },
                    child: Text(
                      "Ngữ pháp",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        elevation: 4,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Từ/Câu yêu thích",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        elevation: 4,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        CupertinoPageRoute(builder: (context)=>LuyenThiSkills())
                      );
                    },
                    child: Text(
                      "Luyện thi TOEIC",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        elevation: 4,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 100.0,
                )
              ],
            ),
          ])),
    );
  }
}
