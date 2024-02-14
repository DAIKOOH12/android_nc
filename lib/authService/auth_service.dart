import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  signInWithGoogle() async {
    final GoogleSignInAccount? ggUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication ggAuth = await ggUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: ggAuth.accessToken,
      idToken: ggAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);

  }

  signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile']
      );
      final OAuthCredential fbAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
      return await FirebaseAuth.instance.signInWithCredential(fbAuthCredential);
    } catch (e) {
      print('Đã xảy ra lỗi khi đăng nhập bằng Facebook: $e');
      // Xử lý lỗi ở đây
    }

  }

}