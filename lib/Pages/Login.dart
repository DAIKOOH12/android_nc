import 'package:english_learning/Pages/MainPage.dart';
import 'package:english_learning/Pages/SignUp.dart';
import 'package:english_learning/global/sessions/SessionsManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../firebase_auth/firebase_auth_services.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController _emaiController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isSigning = false;
  bool _isLoading = false;
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  void dispose() {
    _emaiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text("Đăng nhập"),
                centerTitle: true,
              ),
              body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 1,
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Image(
                          image: AssetImage('assets/images/login_image.jpg')),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
                        child: Text(
                          "Đăng nhập bằng tài khoản của bạn",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15.0,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            Align(
                              child: Text(
                                "Email",
                              ),
                              alignment: Alignment.topLeft,
                            ),
                            SizedBox(
                              height: 50.0,
                              child: TextField(
                                controller: _emaiController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Email",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                              child: Align(
                                child: Text(
                                  "Mật khẩu",
                                ),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                              child: TextFormField(
                                obscureText:true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Mật khẩu"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print("Quên mật khẩu");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Quên mật khẩu?',
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.blue),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Bạn chưa có tài khoản?',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_emaiController.value.text.isNotEmpty &&
                                _passwordController.value.text.isNotEmpty) {
                              setOverlay();
                              _signIn();
                            } else if (_emaiController.value.text.isEmpty ||
                                _passwordController.value.text.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Chú ý"),
                                      content: Text(
                                          'Email và mật khẩu không được để trống!'),
                                    );
                                  });
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_emaiController.text)) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Chú ý"),
                                      content:
                                          Text('Email không đúng định dạng!'),
                                    );
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Đăng nhập",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });
    String email = _emaiController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    setState(() {
      _isSigning = false;
    });
    if (user != null) {
      print("Login Success");
      SessionManager sm=SessionManager();
      sm.setAuthToken(email);
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => MainPage()),ModalRoute.withName('/'));
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

  bool checkError(String email, String password) {
    if (email.isEmpty && password.isEmpty) {
      return false;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return false;
    }
    return true;
  }
}
