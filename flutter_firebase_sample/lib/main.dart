import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_sample/SHARECIPE/project_splashscreen.dart';
import 'package:firebase_sample/firebase_options.dart';
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 83, 0, 10)),
        useMaterial3: true,
      ),
      home: const ProjectSplashscreen(),
    );
  }
}
