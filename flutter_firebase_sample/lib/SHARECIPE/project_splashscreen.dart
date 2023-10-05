import 'package:firebase_sample/SHARECIPE/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_sample/SHARECIPE/login.dart';

class ProjectSplashscreen extends StatefulWidget {
  const ProjectSplashscreen({super.key});

  @override
  State<ProjectSplashscreen> createState() => _ProjectSplashscreenState();
}

class _ProjectSplashscreenState extends State<ProjectSplashscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AuthenticatorPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 83, 0, 10),
              Color.fromARGB(255, 83, 0, 10)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 500,
              child: Image.asset('images/logotext.png'),
            ),
          ],
        ),
      ),
    );
  }
}
