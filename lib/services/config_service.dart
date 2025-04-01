import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ConfigService {
  static Map<String, dynamic> _config = {};

  static Future<void> loadConfig() async {
    if (kReleaseMode) {
      final String response =
          await rootBundle.loadString('assets/config_release.json');
      _config = json.decode(response);
    } else {
      final String response =
          await rootBundle.loadString('assets/config_dev.json');
      _config = json.decode(response);
    }
  }

  static String get apiBaseUrl => _config['apiBaseUrl'] ?? '';
}
