import 'package:flutter/material.dart';
import 'package:german_for_u/pages/dangNhap.dart';
import 'package:german_for_u/pages/dangKy.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {


  bool showLoginPage = true;
  void setLogin() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage)
      {
        return dangNhap(showDangKy: setLogin,);
      }
    else
      {
        return dangKy(showDangNhap: setLogin,);
      }
  }
}
