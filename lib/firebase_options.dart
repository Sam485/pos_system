import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHij1pxnfwzOBABZEVqp8gwqhcydPs2fk',
    appId: '1:768572530085:android:1bcfcfa96aa4ae8c931c4c',
    messagingSenderId: '768572530085',
    projectId: 'pos-system-a6efe',
    storageBucket: 'pos-system-a6efe.firebasestorage.app', // ✅ fixed
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '768572530085',
    projectId: 'pos-system-a6efe',
    storageBucket: 'pos-system-a6efe.firebasestorage.app',
    iosBundleId: 'com.example.posSystem',
  );
}
