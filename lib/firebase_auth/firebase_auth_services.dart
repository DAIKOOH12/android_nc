

import 'package:firebase_auth/firebase_auth.dart';

import '../global/common/toast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth=FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email,String password) async{
    try{
     UserCredential credential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
     return credential.user;
    }on FirebaseAuthException catch(e){
      if(e.code =='email-already-in-use'){
        showToast(message:'Email đã được sử dụng');
        print(e.toString());
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email,String password) async{
    try{
      UserCredential credential=await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      print(e.toString());
    }
    return null;
  }
}