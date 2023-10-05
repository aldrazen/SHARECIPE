import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_sample/SHARECIPE/login.dart';
import 'package:firebase_sample/SHARECIPE/profile.dart';
import 'package:firebase_sample/SHARECIPE/home.dart';
import 'package:firebase_sample/SHARECIPE/toggleScreen.dart';

import 'package:flutter/material.dart';

class AuthenticatorPage extends StatefulWidget {
  const AuthenticatorPage({super.key});

  @override
  State<AuthenticatorPage> createState() => _AuthenticatorPageState();
}

class _AuthenticatorPageState extends State<AuthenticatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else if (snapshot.hasData) {
            return const ProfilePage();
          } else {
            return const ToggleScreen();
          }
        },
      ),
    );
  }
}
