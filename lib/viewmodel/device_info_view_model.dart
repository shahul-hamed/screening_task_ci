import 'package:flutter/material.dart';
import 'package:screening_task_ci/service/device_info_service.dart';

class DeviceInfoViewModel extends ChangeNotifier {
  /// create instance for device info service
  final DeviceInfoService _deviceInfoService = DeviceInfoService();

  // Stream for battery level updates

  late Stream<int> batteryLevelStream;

  List<dynamic> _installedApps = [];
  int _batteryLevel = 0;

  List<dynamic> get installedApps => _installedApps;
  int get batteryLevel => _batteryLevel;

  DeviceInfoViewModel() {
    _listenToBatteryLevel();
  }
  // Fetch installed apps
  Future<void> fetchInstalledApps() async {
    try {
      _installedApps = await _deviceInfoService.getInstalledApps();
    } catch (e) {
      _installedApps = ['Failed to load apps'];
    }
  }
  Future<void> _listenToBatteryLevel() async{
   batteryLevelStream =  await _deviceInfoService.getBatteryLevel();
       batteryLevelStream.listen((level) {
         print("level$level");
      _batteryLevel = level;
      notifyListeners(); // Notify listeners when battery level changes
    });
  }

}
