import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_auth/firebase_auth_services.dart';
import 'Login.dart';
import 'MainPage.dart';
import 'SignUp.dart';

class LoginOptions extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_LoginOptions();
}
class _LoginOptions extends State<LoginOptions> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Wrapper(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Wrapper();
}

class _Wrapper extends State<Wrapper> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
  }

  bool _singedIn = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const Image(
              image: AssetImage('assets/images/toeic_account.jpg'),
              height: 350.0,
            ),
            const Text(
              "HELLO!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 15.0, 15.0),
                child: Text(
                  "Chào mừng bạn đến với ứng dụng học và luyện thi TOEIC!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0, color: Color.fromRGBO(0, 0, 0, 0.5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (context) => Login()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Đăng Nhập",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, elevation: 10),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => SignUp()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Đăng Ký",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, elevation: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 5),
              child: Text(
                "Hoặc đăng nhập bằng",
                style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.blue),
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [BoxShadow()]),
                                child: Image(
                                  image:
                                  AssetImage('assets/images/facebook_icon.png'),
                                  height: 30.0,
                                  width: 30.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Text(
                                  "Facebook",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setOverlay();
                          _signInWithGoogle();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Color.fromRGBO(218, 47, 47, 1.0)),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Image(
                                  image:
                                  AssetImage('assets/images/google_icon.png'),
                                  height: 30.0,
                                  width: 30.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                  child: Text(
                                    "Google",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_isLoading)
          Opacity(
            opacity: 0.8,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }

  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential != null) {
          setState(() {
            _singedIn = true;
          });
        }
        if (_singedIn) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
              ModalRoute.withName('/'));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
  void setOverlay() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _isLoading = false;
    });
  }
}
