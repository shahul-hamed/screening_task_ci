import 'package:flutter/services.dart';
import 'package:screening_task_ci/app/app_utility.dart';

class DeviceInfoService {

  // Fetch the installed apps from the native code (Android and iOS)
  Future<List<dynamic>> getInstalledApps() async {
    try {
      final List<dynamic> apps = await AppUtility.platformMethodChannel.invokeMethod('getInstalledApps');
      return apps;
    } on PlatformException catch (e) {
      print("exception-->${e.toString()}");
      throw Exception("Failed to get installed apps: ${e.message}");
    }
  }

  // Fetch the battery level from the native code
  Future<Stream<int>> getBatteryLevel() async {
    try {
      return AppUtility.batteryChannel.receiveBroadcastStream().map((event) => event as int);
    } on PlatformException catch (e) {
      throw Exception("Failed to get battery level: ${e.message}");
    }
  }
}
