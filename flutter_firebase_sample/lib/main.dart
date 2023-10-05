import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_sample/FirebaseSample/alldata.dart';
import 'package:firebase_sample/FirebaseSample/authenticator.dart';
import 'package:firebase_sample/SHARECIPE/project_splashscreen.dart';
import 'package:firebase_sample/firebase_options.dart';
import 'package:firebase_sample/FirebaseSample/page1.dart';
import 'package:firebase_sample/FirebaseSample/register.dart';
import 'package:firebase_sample/SHARECIPE/authenticator.dart';
import 'package:firebase_sample/SHARECIPE/editProfile.dart';
import 'package:firebase_sample/SHARECIPE/login.dart';
import 'package:firebase_sample/SHARECIPE/profile.dart';
import 'package:firebase_sample/SHARECIPE/register.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 83, 0, 10)),
        useMaterial3: true,
      ),
      home: const ProjectSplashscreen(),
    );
  }
}
