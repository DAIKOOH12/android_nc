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
      // var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail("hieungu@gmail.com");
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: "1@gmail.com");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Check your email!!!"),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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

              MaterialButton(
                color: Colors.blue,
                onPressed: resetPass,
                child: Text('Đặt lại mật khẩu'),
              ),
              
              
              Text('fsjkfhdfkj')

            ],
          ),
        ),
    );
  }
}
