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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC8Bg358apP0Oxo7SOnI2_wMelOeJt0Lls',
    appId: '1:219034345526:web:eac4afe3a46e74f2d83897',
    messagingSenderId: '219034345526',
    projectId: 'receipt-genius',
    authDomain: 'receipt-genius.firebaseapp.com',
    storageBucket: 'receipt-genius.appspot.com',
    measurementId: 'G-JG7MGGSR72',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2n76lLzZ6V6ar9X6_1_udXE2EEOIpFq8',
    appId: '1:219034345526:android:ad3083d8cde2b661d83897',
    messagingSenderId: '219034345526',
    projectId: 'receipt-genius',
    storageBucket: 'receipt-genius.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1UzTJZfb7H6op6SS7vlzUoJbOxsEPK2Q',
    appId: '1:219034345526:ios:45cdd93b8e02b08ed83897',
    messagingSenderId: '219034345526',
    projectId: 'receipt-genius',
    storageBucket: 'receipt-genius.appspot.com',
    iosBundleId: 'com.example.receiptGenius',
  );
}
