import 'dart:io';

import 'package:flutter/services.dart';

class AppUtility {
  static const platformMethodChannel = MethodChannel('com.task.screening_ci/installed_apps');
  static const EventChannel batteryChannel = EventChannel('com.task.screening_ci/battery');
  static Future<bool> isInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return true;
  }
}