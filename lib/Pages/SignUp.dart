import 'package:english_learning/Pages/MainPage.dart';
import 'package:english_learning/firebase_auth/firebase_auth_services.dart';
import 'package:english_learning/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_SignUp();

}
class _SignUp extends State<SignUp>{
  TextEditingController _userNameController=TextEditingController();
  TextEditingController _emaiController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _repasswordController=TextEditingController();

  final FirebaseAuthService _auth=FirebaseAuthService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text('Đăng Ký'),
              ),
              body: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: 300.0,
                      height: 300.0,
                      child: Image(
                          image: AssetImage('assets/images/signup_image.png')),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Đăng ký tài khoản cho riêng bạn",
                      style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          Align(
                            child: Text("Họ và tên"),
                            alignment: Alignment.topLeft,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                            child: Container(
                              height: 50.0,
                              child: TextField(
                                controller: _userNameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Nhập họ tên của bạn'),
                              ),
                            ),
                          ),
                          Align(
                            child: Text("Email"),
                            alignment: Alignment.topLeft,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                            child: Container(
                              height: 50.0,
                              child: TextField(
                                controller: _emaiController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Nhập email của bạn',
                                ),
                              ),
                            ),
                          ),
                          Align(
                            child: Text("Mật khẩu"),
                            alignment: Alignment.topLeft,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                            child: Container(
                              height: 50.0,
                              child: TextField(
                                obscureText: true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Nhập mật khẩu'),
                              ),
                            ),
                          ),
                          Align(
                            child: Text("Xác nhận mật khẩu"),
                            alignment: Alignment.topLeft,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                            child: Container(
                              height: 50.0,
                              child: TextField(
                                obscureText: true,
                                controller: _repasswordController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Nhập lại mật khẩu'),
                              ),
                            ),
                          ),
                          ElevatedButton(onPressed: () {
                            setOverlay();
                            _signUp();
                          },
                              child: Text('Đăng Ký',style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: Colors.blue
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
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
  void _signUp() async{
    String username=_userNameController.text;
    String email=_emaiController.text;
    String password=_passwordController.text;

    User? user=await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      _isLoading=true;
    });
    if(user!=null&&email!=null&&password!=null){
      print("Created");
      Navigator.push(context,
      MaterialPageRoute(builder: (context)=>MainPage())
      );
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
