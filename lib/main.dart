import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:german_for_u/firebase_options.dart';
import 'package:german_for_u/pages/dangKy.dart';

import 'package:german_for_u/pages/dangNhap.dart';
import 'package:german_for_u/auth/main_page.dart';
import 'package:german_for_u/pages/theGhiNhoTV.dart';
import 'package:german_for_u/pages/trangChu.dart';

Future main() async {

  // WidgetsFlutterBinding.ensureInitialized();
  // if(kIsWeb) {
  //   Firebase.initializeApp(options:
  //   FirebaseOptions(
  //       apiKey: "AIzaSyB3Du6aN2iMY-bG77bijJAac4QlyLS7BXA",
  //       authDomain: "german-for-u.firebaseapp.com",
  //       projectId: "german-for-u",
  //       storageBucket: "german-for-u.appspot.com",
  //       messagingSenderId: "446152477698",
  //       appId: "1:446152477698:web:97c6d6cdba10969ab56b1b"
  //
  //
  //   )
  //   );
  // }
  // else
  //   await Firebase.initializeApp();
  // runApp(const MyApp());

  await dotenv.load(fileName: ".env");

  String api_key = dotenv.get("API_KEY_FIREBASE", fallback: "");
  String app_id = dotenv.get("APP_ID_FIREBASE", fallback: "");
  String messagingSenderId = dotenv.get("messagingSenderId_Firebase", fallback: "");

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    print("ddd");
    try {
      await Firebase.initializeApp(
          options: const FirebaseOptions(

              apiKey: "AIzaSyB3Du6aN2iMY-bG77bijJAac4QlyLS7BXA",
              authDomain: "german-for-u.firebaseapp.com",
              projectId: "german-for-u",
              storageBucket: "german-for-u.appspot.com",
              messagingSenderId: "446152477698",
              appId: "1:446152477698:web:97c6d6cdba10969ab56b1b"

          )
      );
    } catch (e) {
      print(e.toString());
    }

  }
  else
     {
       Platform.isAndroid
           ? await Firebase.initializeApp(
           options: FirebaseOptions(
               apiKey: api_key,
               appId: app_id,
               messagingSenderId: messagingSenderId,
               projectId: "german-for-u"))
           : await Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            );
     }
       runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      // home: theGhiNhoTV(),
      debugShowCheckedModeBanner: false,
    );
  }
}
