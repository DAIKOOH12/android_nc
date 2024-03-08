import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class quenMatKhau extends StatefulWidget {
  const quenMatKhau({super.key});

  @override
  State<quenMatKhau> createState() => _quenMatKhauState();
}

class _quenMatKhauState extends State<quenMatKhau> {

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future resetPass() async {
    final result = await FirebaseFirestore.instance.collection('user')
    .doc(_emailController.text)
    .get();

    if(result.exists) {
      print('fdf');
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Check your email!!!"),
              );
            });
      } on FirebaseAuthException catch (e) {
        if(!e.message.toString().contains('ff'));
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(e.message.toString()),
              );
            });
      }
    }
    else{
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Email của bạn chưa được đăng ký!'),
            );
          });
      Future.delayed(Duration(milliseconds: 2300), () {
        Navigator.of(context).pop();
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo_gfu.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 50,),

              Container(
                width: 320,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Chúng tôi sẽ gửi cho một một email chứa đường dẫn tới nơi đặt lại mật khẩu của bạn. Hãy nhập email được liên kết với tài khoản của bạn vào ô bên dưới',
                  style: TextStyle(

                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              SizedBox(height: 20,),
              Container(
                width: 300,
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(17))
                ),
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(fontSize: 19),
                  decoration: InputDecoration(
                    hintText: 'Nhập email của bạn',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none
                    ),
                    hintStyle: TextStyle(fontSize: 19)
                  ),
                ),
              ),

              SizedBox(height: 25,),
              Container(
                height: 40,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                  color: Color(0xFF3ABA77),
                  onPressed: resetPass,
                  child: Text('Đặt lại mật khẩu', style: TextStyle(fontSize: 18),),
                ),
              ),

            ],
          ),
        ),
    );
  }
}
