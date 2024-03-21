import 'package:english_learning/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: ()async{
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context)=>MyApp()),ModalRoute.withName('/')
            );
          },
          child: Text('Đăng xuất'),
        ),
      ),
    );
  }

}