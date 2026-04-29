import 'package:flutter/foundation.dart';

class Config {
  static String get apiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api'; // Chrome
    }
    return 'http://10.0.2.2:3000/api'; // Émulateur Android
  }
}