// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCpMmq3OA5YpLmFbSPEYcrpg6DJEfOFAAA',
    appId: '1:159770951696:web:ab7c8f4c6303df03a18a95',
    messagingSenderId: '159770951696',
    projectId: 'selfa-38b7e',
    authDomain: 'selfa-38b7e.firebaseapp.com',
    storageBucket: 'selfa-38b7e.appspot.com',
    measurementId: 'G-GP0XMC8PMT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1QbzsV1WpL3-bn8WwDTPhBPx_FJ2eRto',
    appId: '1:159770951696:android:496beb20b9908a11a18a95',
    messagingSenderId: '159770951696',
    projectId: 'selfa-38b7e',
    storageBucket: 'selfa-38b7e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjyvF8ui_gUrVMwDU8vxUQeRqwbxRFCEQ',
    appId: '1:159770951696:ios:1be74009dda8a8a3a18a95',
    messagingSenderId: '159770951696',
    projectId: 'selfa-38b7e',
    storageBucket: 'selfa-38b7e.appspot.com',
    iosClientId: '159770951696-rakptjg7lf5fdtf8g7g57mp34ab65klo.apps.googleusercontent.com',
    iosBundleId: 'com.example.expenseApp',
  );

}