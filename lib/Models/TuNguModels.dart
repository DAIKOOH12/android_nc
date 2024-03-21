import 'package:cloud_firestore/cloud_firestore.dart';

class TuNguModels{
  String? engword;
  String? vieword;

  TuNguModels( { this.engword,  this.vieword});

  static TuNguModels fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return TuNguModels(engword: snapshot['engword'], vieword: snapshot['vieword']);
  }
}