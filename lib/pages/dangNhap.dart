import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:german_for_u/authService/auth_service.dart';
import 'package:german_for_u/pages/quenMatKhau.dart';
import 'package:google_fonts/google_fonts.dart';

class dangNhap extends StatefulWidget {
  final VoidCallback showDangKy;
  const dangNhap({super.key, required this.showDangKy});

  @override
  State<dangNhap> createState() => _dangNhapState();
}

class _dangNhapState extends State<dangNhap> {


  final _emailController =  TextEditingController();
  final _passwordController = TextEditingController();
  List<String> error = [];

  Future SignIn() async {

    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    error = [];
    if(_passwordController.text.trim() == "") {
      setState(() {
        error.add("Bạn chưa nhập mật khẩu");
      });
    }
    if(_emailController.text.trim() == "") {
      setState(() {
        error.add("Bạn chưa nhập email");
      });
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(), password: _passwordController.text.trim()
      );
    }
    catch(e) {
      print(e.toString());
      if(e.toString().contains('invalid-credential'))
      {
        setState(() {
          error.add("Tài khoản hoặc mật khẩu không chính xác!");
        });
      }
      if(e.toString().contains('invalid-email')) {
        setState(() {
          error.add("Email chưa đúng định dạng");
        });
      }
      
    }

    Navigator.of(context).pop();
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(
          backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            //logo
            SizedBox(
              height: 40,
            ),
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

            SizedBox(height: 40,),
            Center(
              child: Text(
                'Chào mừng bạn đến với GERMAN FOR U!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF3ABA77),
                  fontWeight: FontWeight.w500,
                  fontSize: 24
                ),
              ),
            ),

            SizedBox(height: 20,),
            Center(
              child: Text(
                'Đăng nhập bằng tài khoản của bạn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF3ABA77),
                  fontWeight: FontWeight.w500,
                  fontSize: 15
                ),
              ),
            ),

            // Facebook+google
            // SizedBox(
            //   height: 40,
            // ),
            // Container(
            //   width: 345,
            //   height: 41,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       GestureDetector(
            //         onTap: () => AuthService(context).signInWithFacebook(),
            //         child: Container(
            //           width: 40,
            //           height: 41,
            //           decoration: BoxDecoration(
            //             image: DecorationImage(
            //               image: AssetImage('images/facebook.webp'),
            //               fit: BoxFit.fill,
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 50),
            //       GestureDetector(
            //         onTap: () {
            //
            //           AuthService(context).signInWithGoogle();
            //           // Navigator.of(context).pop();
            //         },
            //         child: Container(
            //           width: 40,
            //           height: 41,
            //           decoration: BoxDecoration(
            //             image: DecorationImage(
            //               image: AssetImage('images/google.png'),
            //               fit: BoxFit.fill,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            //
            // //Hoặc đăng nhập với
            // SizedBox(
            //   height: 20,
            // ),
            // Text(
            //   'Hoặc đăng nhập với tài khoản',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     color: Colors.black.withOpacity(0.5),
            //     fontSize: 12,
            //     fontFamily: 'DM Sans',
            //     fontWeight: FontWeight.w700,
            //     height: 0,
            //   ),
            // ),


            //Email
            SizedBox(
              height: 20,
            ),
            Container(
              width: 298,
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
                    width: 200,
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
              width: 298,
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
                    width: 200,
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

            //Hiện lỗi đăng nhập
            SizedBox(height: 3,),
            Container(
              width: 298,
              child: Text(
                error.join(", "),
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),


            // Quên mật khẩu hoặc đăng ký
            SizedBox(
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return quenMatKhau();
                          }
                        )
                    );
                  },
                  child: Text(
                    'Quên mật khẩu?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3BBAB8),
                      fontSize: 12,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.showDangKy,
                  child: Text(
                    'Đăng ký tài khoản',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3B7DBA),
                      fontSize: 12,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                )
              ],
            ),



            // Container(
            //   width: 298,
            //   height: 50,
            //   // color: Color(0xFF3B5998),
            //   child: MaterialButton(
            //     onPressed: () {
            //
            //     },
            //     child: Row(
            //       children: [
            //         Container(
            //           width: 30,
            //           height: 30,
            //           decoration: BoxDecoration(
            //             image: DecorationImage(
            //               image: AssetImage('images/google.png'),
            //               fit: BoxFit.fill,
            //             ),
            //           ),
            //         ),
            //         Text("Đăng nhập bằng Google")
            //       ],
            //     ),
            //   ),
            // ),


            // nút đăng nhập
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: SignIn,
              child: Container(
                width: 287,
                height: 44,
                padding: const EdgeInsets.all(10),
                // color: Color(0xFF3ABA77),
                decoration: ShapeDecoration(
                  color: Color(0xFF447143),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),

                  ),
                  // shadows: [
                  //   BoxShadow(
                  //     color: Color(0xD1006A0A),
                  //     blurRadius: 16,
                  //     offset: Offset(0, 8),
                  //     spreadRadius: 0,
                  //   )
                  // ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Đăng nhập',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Phetsarath',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 5,),
            Container(
              height: 50, // Chiều cao của đoạn văn bản và đường kẻ ngang
              child: Stack(
                children: [
                  // Đường kẻ ngang
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 24,
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(),
                        width: 240,
                        height: 1,
                        color: Colors.grey, // Màu của đường kẻ ngang
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  // Văn bản
                  Center(
                    child: Container(
                      width: 60,
                      // margin: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'Hoặc', // Nội dung văn bản
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            backgroundColor: Colors.white, // Màu nền của văn bản
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),



            //hoặc đăng nhập với
            SizedBox(height: 3,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 152,
                  height: 55,
                  padding: EdgeInsets.zero,
                  child: ElevatedButton.icon(

                    label: Text('Facebook', style: TextStyle(color: Colors.white, fontSize: 18),),
                    icon: Container(
                        width: 25,
                        height: 25,
                        child: ImageIcon(AssetImage('images/facebook.png'),color: Colors.white,
                        )
                    ),

                    onPressed: () {
                      AuthService(context).signInWithFacebook();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFF3B5998)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Độ cong của góc
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                    ),
                  ),
                ),

                SizedBox(width: 4,),

                Container(
                  width: 152,
                  height: 55,
                  child: ElevatedButton.icon(

                    label: Text('Google', style: TextStyle(color: Colors.black, fontSize: 18),),
                    icon: Container(
                      width: 30,
                      height: 30,
                      // margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/google.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    onPressed: () {
                      AuthService(context).signInWithGoogle();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Độ cong của góc
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                    ),
                  ),
                ),
              ],
            ),





          ],
        ),
      ),
    ));
  }
}

// dColor: Colors.grey[100],
// body: Column(
//   children: [
//     const SizedBox(
//       height: 50,
//     ),
//     // Đăng nhập
//     Center(
//       child: Text('Đăng nhập', style: GoogleFonts.roboto(fontSize: 36)),
//     ),
//
//     //hoặc đăng nhập với tài khoản
//     Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           decoration: const BoxDecoration(
//               // color: Colors.grey
//               ),
//           width: 300,
//           height: 50,
//         ),
//         Container(
//           height: 1.5,
//           width: 300,
//           color: Color(0xff3BBAB8),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 7),
//           decoration: BoxDecoration(color: Colors.grey[100]),
//           child: Text(
//             'Hoặc đăng nhập với tài khoản',
//             style: GoogleFonts.dmSans(
//                 backgroundColor: Colors.grey[100], color: Colors.black),
//           ),
//         )
//       ],
//     ),
//
//     //Email
//     Container(
//       width: 300,
//       height: 70,
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//           border: Border.all(
//               width: 1.5, color: Color(0xff006A0B).withOpacity(0.45)),
//           borderRadius: BorderRadius.circular(17)),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//
//           Icon(Icons.email_outlined),
//           Icon(Icons.password),
//           TextField(
//             decoration: InputDecoration(
//               hintText: 'Email',
//               border: InputBorder.none,
//             ),
//           )
//         ],
//       ),
//     )
//   ],
// ),
