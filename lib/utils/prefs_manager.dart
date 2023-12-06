import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  //static allows for calling without creating an instance of the class
  static String? deviceId;

  static Future<void> saveDeviceID() async {
    String? deviceId = await PlatformDeviceId.getDeviceId; //get the ID
    final prefs = await SharedPreferences.getInstance(); //get sharedPrefs

    if (deviceId != null) {
      prefs.setString('device_id', deviceId);
    }
  }

  static Future<String?> getDeviceID() async {
    final prefs = await SharedPreferences.getInstance(); 
    return prefs.getString('device_id');
  }
}
