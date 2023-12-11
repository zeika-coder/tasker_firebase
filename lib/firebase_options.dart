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
    apiKey: 'AIzaSyA3zED0Rd3OncK62mU_ORftKwvUG2nJB3s',
    appId: '1:574267044336:web:6ae071e7685d8c4602ad35',
    messagingSenderId: '574267044336',
    projectId: 'tasker-e9a49',
    authDomain: 'tasker-e9a49.firebaseapp.com',
    storageBucket: 'tasker-e9a49.appspot.com',
    databaseURL: 'https://tasker-e9a49-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBD88SyrYlkrVRRDewBYG2dhxvnYH_15KA',
    appId: '1:574267044336:android:c753a3e076990ee102ad35',
    messagingSenderId: '574267044336',
    projectId: 'tasker-e9a49',
    storageBucket: 'tasker-e9a49.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1OlKhYf5A1XGk8OaWQpVPs5Qg4wxUK2E',
    appId: '1:574267044336:ios:4fc22e538651c47002ad35',
    messagingSenderId: '574267044336',
    projectId: 'tasker-e9a49',
    storageBucket: 'tasker-e9a49.appspot.com',
    iosBundleId: 'com.andreasg.taskManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB1OlKhYf5A1XGk8OaWQpVPs5Qg4wxUK2E',
    appId: '1:574267044336:ios:4fc22e538651c47002ad35',
    messagingSenderId: '574267044336',
    projectId: 'tasker-e9a49',
    storageBucket: 'tasker-e9a49.appspot.com',
    iosBundleId: 'com.andreasg.taskManager',
  );
}