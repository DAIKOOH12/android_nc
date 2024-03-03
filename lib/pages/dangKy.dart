import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class dangKy extends StatefulWidget {
  final VoidCallback showDangNhap;
  const dangKy({super.key, required this.showDangNhap});

  @override
  State<dangKy> createState() => _dangKyState();
}

class _dangKyState extends State<dangKy> {

  final _emailController =  TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _name = TextEditingController();

  List<String> error = [];

  Future SignUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );


    error=[];
    if(_emailController.text.trim() == ""){
      setState(() {
        error.add("Email không được để trống");
      });
    }
    if(_name.text.trim() == ""){
      setState(() {
        error.add("Họ tên không được để trống");
      });
    }
    if(_passwordController.text.trim() == ""){
      setState(() {
        error.add("Mật khẩu không được để trống");
      });
    }


    if(confirmPass()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text
        );
        addUser(_name.text.trim(), _emailController.text.trim());

      }

      catch (e) {
        if(e.toString().contains("invalid-email")) {
          setState(() {

          error.add("Email chưa đúng định dạng");
          });
        }
        if(e.toString().contains('weak-password')) {
          setState(() {
          error.add("Mật khẩu phải có độ dài từ 6 trở lên");

          });
        }

        print(e.toString());
      }
    }
    else {
      setState(() {
      error.add("Mật khẩu chưa khớp");

      });
    }

    Navigator.of(context).pop();


  }

  Future addUser (String name, String email) async {
    DateTime today = DateTime.now();
    try {
      // await FirebaseFirestore.instance.collection('users').add({
      //   'hoTen' : name,
      // });
      Map<String, dynamic> data = {
        'hoTen': name,
        'dNgayBatDau': today.day.toString() + "/"
            + today.month.toString() + "/"
            + today.year.toString(),
        // Thêm các trường khác nếu cần
      };
      await FirebaseFirestore.instance.collection('user').doc(email).set(data);
    } catch (e) {
      print(e);
    }

  }

  bool confirmPass() {
    var pass = _passwordController.text.trim();
    var confirm =  _confirmPassword.text.trim();
    if( pass == confirm){
      return true;
    }
    else return false;
  }




  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [

                //Đăng nhập
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    'Đăng ký tài khoản',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3ABA77),
                      fontSize: 24,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),

                //logo
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 171,
                  height: 171,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/logo_gfu.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),


                //Họ tên:
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: size.width * 0.85,
                  height: 57,
                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.50, color: Color(0x72006A0A)),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 11,
                        offset: Offset(0, 7),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(children: [
                          Opacity(
                              opacity: 0.5,
                              child: Icon(
                                Icons.account_circle_outlined,
                              )),
                        ]),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: size.width*0.6,
                        height: 20,
                        child: TextField(
                          controller: _name,
                          decoration: InputDecoration(
                            hintText: 'Họ tên',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),




                //Email
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: size.width * 0.85,
                  height: 57,
                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.50, color: Color(0x72006A0A)),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 11,
                        offset: Offset(0, 7),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(children: [
                          Opacity(
                              opacity: 0.5,
                              child: Icon(
                                Icons.email_outlined,
                              )),
                        ]),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: size.width*0.6,
                        height: 20,
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //password
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: size.width * 0.85,
                  height: 57,
                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.50, color: Color(0x72006A0A)),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 11,
                        offset: Offset(0, 7),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(children: [
                          Opacity(
                              opacity: 0.5,
                              child: Icon(
                                Icons.lock_outline_rounded,
                              )),
                        ]),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: size.width * 0.6,
                        height: 20,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                // nhắc lại password
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: size.width * 0.85,
                  height: 57,
                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.50, color: Color(0x72006A0A)),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 11,
                        offset: Offset(0, 7),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(children: [
                          Opacity(
                              opacity: 0.5,
                              child: Icon(
                                Icons.lock_outline_rounded,
                              )),
                        ]),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: size.width * 0.6,
                        height: 20,
                        child: TextField(
                          controller: _confirmPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Nhập lại mật khẩu',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Báo lỗi
                SizedBox(height: 7,),
                Container(
                  width: size.width * 0.85,
                  child: Text(
                    error.join(", "),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                      fontSize: 10
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                GestureDetector(
                  onTap:
                    widget.showDangNhap,
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      'Đăng nhập bằng tài khoản',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF3B7DBA),
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),


                // nút đăng ký
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: SignUp,
                  child: Container(
                    width: size.width * 0.85,
                    height: 57,
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: Color(0xFF3ABA77),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0xD1006A0A),
                          blurRadius: 10,
                          offset: Offset(0, 8),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Đăng ký',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Phetsarath',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 40,
                ),

              ],
            ),
          ),
        ));
  }
}
