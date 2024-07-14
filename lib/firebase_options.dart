import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    }
    throw UnsupportedError('Platform not supported.');
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDzkJD-PeI0aTgWnADZFLjbicRovPnGxkg",
    appId: "1:14655649036:android:8a0b4835ed345994838529",
    messagingSenderId: "14655649036",
    projectId: "fastcampus-market-c5a55",
    authDomain: "fastcampus-market-c5a55.firebaseapp.com",
    storageBucket: "fastcampus-market-c5a55.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAtFpvwiCQQAizp8eqBahAeqoY_9fLKrys",
    appId: "1:14655649036:ios:aa991969c3e6a182838529",
    messagingSenderId: "14655649036",
    projectId: "fastcampus-market-c5a55",
    authDomain: "fastcampus-market-c5a55.firebaseapp.com",
    storageBucket: "fastcampus-market-c5a55.appspot.com",
    iosClientId: "14655649036-xxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com",
    iosBundleId: "com.example.flutterMovingScreen",
  );


}
