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
    apiKey: 'AIzaSyDqVlapCi2lDQlywfRMT0AhdAMo3-vsPbw',
    appId: '1:803599202489:web:1155b1d780d56d423d8368',
    messagingSenderId: '803599202489',
    projectId: 'today-s-kanji',
    authDomain: 'today-s-kanji.firebaseapp.com',
    storageBucket: 'today-s-kanji.appspot.com',
    measurementId: 'G-059Z092T54',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8g8cFCOVWwqQsKFtZSqnSM3fDISfjprA',
    appId: '1:803599202489:android:41fb1593eff250c53d8368',
    messagingSenderId: '803599202489',
    projectId: 'today-s-kanji',
    storageBucket: 'today-s-kanji.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-bhHF1NudoeRT-9I0wiWvz_0Q4Bqu5Ds',
    appId: '1:803599202489:ios:638c2f3523fbfc483d8368',
    messagingSenderId: '803599202489',
    projectId: 'today-s-kanji',
    storageBucket: 'today-s-kanji.appspot.com',
    iosClientId: '803599202489-riv6ar95teml90khann1fbotuai9ll6k.apps.googleusercontent.com',
    iosBundleId: 'com.example.sample',
  );
}
