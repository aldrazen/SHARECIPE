// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAT278_rQJTB-9fwaeCeO-Wb1c9Q20rJFI',
    appId: '1:27261343503:web:cdff63de5eaeddd6f1907a',
    messagingSenderId: '27261343503',
    projectId: 'flutterdb-55aaf',
    authDomain: 'flutterdb-55aaf.firebaseapp.com',
    storageBucket: 'flutterdb-55aaf.appspot.com',
    measurementId: 'G-LJMP625E32',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5_VRX5wk79GApguUwSBlg-XuhaZOD2ao',
    appId: '1:27261343503:android:7800ff006d7a974df1907a',
    messagingSenderId: '27261343503',
    projectId: 'flutterdb-55aaf',
    storageBucket: 'flutterdb-55aaf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0LKa1uFCeywNuKhGmOYnWvGA818Fv-W0',
    appId: '1:27261343503:ios:13a9a78f5272daf4f1907a',
    messagingSenderId: '27261343503',
    projectId: 'flutterdb-55aaf',
    storageBucket: 'flutterdb-55aaf.appspot.com',
    iosBundleId: 'com.example.firebaseSample',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0LKa1uFCeywNuKhGmOYnWvGA818Fv-W0',
    appId: '1:27261343503:ios:18a8eab0b8412097f1907a',
    messagingSenderId: '27261343503',
    projectId: 'flutterdb-55aaf',
    storageBucket: 'flutterdb-55aaf.appspot.com',
    iosBundleId: 'com.example.firebaseSample.RunnerTests',
  );
}
