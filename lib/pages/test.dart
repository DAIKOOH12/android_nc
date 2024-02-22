import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class newT extends StatefulWidget {
  const newT({super.key});

  @override
  State<newT> createState() => _newState();
}

class _newState extends State<newT> {

  String aa = "";

  Future getContent() async {
    final a = await FirebaseFirestore.instance.collection('CTHT - nguPhap').get();

    a.docs.forEach((element) {
      setState(() {
        aa = element['ff'];
      });
    });

  }


  @override
  void initState() {
    super.initState();
    getContent();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Text(
            aa + "lflf"
          ),
        ),
      ),
    );
  }
}
