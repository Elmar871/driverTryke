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
    apiKey: 'AIzaSyCJr3emtLGuElHUYNY28Ab0gbajnvPCEp8',
    appId: '1:29403172094:web:7b5f4e00e48a1b2a6aa9af',
    messagingSenderId: '29403172094',
    projectId: 'trippo-1eb43',
    authDomain: 'trippo-1eb43.firebaseapp.com',
    databaseURL: 'https://trippo-1eb43-default-rtdb.firebaseio.com',
    storageBucket: 'trippo-1eb43.appspot.com',
    measurementId: 'G-Y86M6CNXPR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0ak_aEyb_JJ1WAhZ0x4BhzYYjrUJi5Cg',
    appId: '1:513185890115:android:5cf2ca50b3fd348313b9f6',
    messagingSenderId: '513185890115',
    projectId: 'tryke-app-with-admin-fd5e0',
    databaseURL: 'https://tryke-app-with-admin-fd5e0-default-rtdb.firebaseio.com',
    storageBucket: 'tryke-app-with-admin-fd5e0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCjrd2UgBE96b5VLzMDll4O2Ke4tvCZTy8',
    appId: '1:29403172094:ios:c4debf0a24fd5c3a6aa9af',
    messagingSenderId: '29403172094',
    projectId: 'trippo-1eb43',
    databaseURL: 'https://trippo-1eb43-default-rtdb.firebaseio.com',
    storageBucket: 'trippo-1eb43.appspot.com',
    iosClientId: '29403172094-8gkc2eln04rr1jtjdfufdmrts6mokj7i.apps.googleusercontent.com',
    iosBundleId: 'com.egoncastle.drivers',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCjrd2UgBE96b5VLzMDll4O2Ke4tvCZTy8',
    appId: '1:29403172094:ios:c4debf0a24fd5c3a6aa9af',
    messagingSenderId: '29403172094',
    projectId: 'trippo-1eb43',
    databaseURL: 'https://trippo-1eb43-default-rtdb.firebaseio.com',
    storageBucket: 'trippo-1eb43.appspot.com',
    iosClientId: '29403172094-8gkc2eln04rr1jtjdfufdmrts6mokj7i.apps.googleusercontent.com',
    iosBundleId: 'com.egoncastle.drivers',
  );
}
