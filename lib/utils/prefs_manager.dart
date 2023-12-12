import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static String? deviceId;
  
  //DEVICE ID
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

  //SESSION ID
  static Future<void> saveSessionID(String id) async {
    final prefs = await SharedPreferences.getInstance(); //get sharedPrefs
    prefs.setString('session_id', id);
    
  }

  static Future<String?> getSessionID() async {
    final prefs = await SharedPreferences.getInstance(); 
    return prefs.getString('session_id');
  }
}
