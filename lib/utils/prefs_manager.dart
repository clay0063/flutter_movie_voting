import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static String? deviceId;
  static String? sessionId;

  //DEVICE ID
  static Future<void> saveDeviceID() async {
    String? deviceId = await _getID(); //get the ID
    final prefs = await SharedPreferences.getInstance(); //get sharedPrefs

    if (deviceId != null) {
      prefs.setString('device_id', deviceId);
    }
  }

  static Future<String?> _getID() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.fingerprint;
    }
    return null;
  }

  static Future<String?> getDeviceID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('device_id');
  }

  //SESSION ID
  static Future<void> saveSessionID(String id) async {
    final prefs = await SharedPreferences.getInstance(); //get sharedPrefs
    prefs.setString('session_id', id);

    sessionId = id;
  }

  static Future<String?> getSessionID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id');
  }
}
