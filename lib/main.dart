import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:german_for_u/pages/dangKy.dart';

import 'package:german_for_u/pages/dangNhap.dart';
import 'package:german_for_u/auth/main_page.dart';
import 'package:german_for_u/pages/trangChu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  String api_key = dotenv.get("API_KEY_FIREBASE", fallback: "");
  String app_id = dotenv.get("APP_ID_FIREBASE", fallback: "");
  String messagingSenderId = dotenv.get("messagingSenderId_Firebase", fallback: "");

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: api_key,
              appId: app_id,
              messagingSenderId: messagingSenderId,
              projectId: "german-for-u"))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
