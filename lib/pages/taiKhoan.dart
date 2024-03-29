import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/auth/main_page.dart';
import 'package:german_for_u/pages/tienDo.dart';
import 'package:german_for_u/pages/tienDoHomNay.dart';
import 'package:google_sign_in/google_sign_in.dart';
class taiKhoan extends StatefulWidget {
  const taiKhoan({super.key});

  @override
  State<taiKhoan> createState() => _taiKhoanState();
}

class _taiKhoanState extends State<taiKhoan> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              MaterialButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return tienDoHomNay();
                  }));
                },
                minWidth: size.width * 0.75,
                color: Colors.grey[200],
                child: Text(
                  'Quá trình học tập',
                  style: TextStyle(

                  ),
                ),
              ),
              MaterialButton(
                onPressed: (){

                },
                minWidth: size.width * 0.75,
                color: Colors.grey[200],
                child: Text(
                  'Đổi mật khẩu',
                  style: TextStyle(
                  ),
                ),
              ),
              MaterialButton(
                onPressed: (){},
                minWidth: size.width * 0.75,
                color: Colors.grey[200],
                child: Text(
                  'Thông tin tài khoản',
                  style: TextStyle(

                  ),
                ),
              ),
              Center(
                child: MaterialButton(
                  color: Colors.purple[200],
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                        (Route<dynamic> route) => false,
                    );
                    // MainPage();
                    // dispose();
                    // FirebaseAuth.instance.ononAuthStateChanged(function(user) {
                    // if (user) {
                    // // User is signed in.
                    // user.providerData.forEach(function(profile) {
                    // console.log("Signed in with:", profile.providerId);
                    // });
                    // } else {
                    // // No user is signed in.
                    // }
                    // });

                  },
                  child: Text('Sign out'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
