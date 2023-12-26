import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        appId: '',
        apiKey: '',
        projectId: '',
        messagingSenderId: '',
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '',
        apiKey: '',
        projectId: '',
        messagingSenderId: '',
        iosBundleId: '',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:1030276386601:android:41c50003711161d13ab138',
        apiKey: 'AIzaSyAwmwUrbDgXy47B7uu5m_5-I42c3v4TFNE',
        projectId: 'kivicare-5d319',
        messagingSenderId: '1030276386601',
        storageBucket: 'kivicare-5d319.appspot.com',
      );
    }
  }
}
