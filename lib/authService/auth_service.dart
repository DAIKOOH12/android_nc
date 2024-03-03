import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  BuildContext context;

  AuthService(this.context);

  DateTime today = DateTime.now();

  signInWithGoogle() async {
    final GoogleSignInAccount? ggUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication ggAuth = await ggUser!.authentication;

    if (ggUser == null) {
      // Xử lý trường hợp không có người dùng đăng nhập
      return null;
    }


    final credential = GoogleAuthProvider.credential(
      accessToken: ggAuth.accessToken,
      idToken: ggAuth.idToken,
    );

    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    var result =  await FirebaseAuth.instance.signInWithCredential(credential);
    if(result.additionalUserInfo!.isNewUser){
      try {
        // String ngayBatDau =
        // await FirebaseFirestore.instance.collection('users').add({
        //   'hoTen' : name,
        // });
        var user = result.user;
        Map<String, dynamic> data = {
          'hoTen': user!.displayName,
          'dNgayBatDau': today.day.toString() + "/"
              + today.month.toString() + "/"
              + today.year.toString(),
          // Thêm các trường khác nếu cần
        };
        await FirebaseFirestore.instance.collection('user').doc(user.email).set(data);
      } catch (e) {
        print(e);
      }
    }
    Navigator.of(context).pop();
    return result;

  }

  signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile']
      );
      final OAuthCredential fbAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
      final userCredential =  await FirebaseAuth.instance.signInWithCredential(fbAuthCredential);

      if(userCredential.additionalUserInfo!.isNewUser) {
        try {
          // await FirebaseFirestore.instance.collection('users').add({
          //   'hoTen' : name,
          // });
          var user = userCredential.user;
          Map<String, dynamic> data = {
            'hoTen': user!.displayName,
            'dNgayBatDau': today.day.toString() + "/"
                + today.month.toString() + "/"
                + today.year.toString(),
            // Thêm các trường khác nếu cần
          };
          await FirebaseFirestore.instance.collection('user').doc(user.email).set(data);
        } catch (e) {
          print(e);
        }
      }

      return userCredential;

    } catch (e) {
      print('Đã xảy ra lỗi khi đăng nhập bằng Facebook: $e');
      // Xử lý lỗi ở đây
    }

  }

}