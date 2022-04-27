import 'package:shared_preferences/shared_preferences.dart';

class DataSharedPreferences {
  static SharedPreferences? _preferences;

  static Future init() async =>
    _preferences = await SharedPreferences.getInstance();

  static Future setPillList(String pillList) async =>
    await _preferences?.setString('pillList', pillList);
  static String getPillList() => _preferences?.get('pillList') as String;

  static Future setRingDuration(int ringDuration) async =>
    await _preferences?.setInt('ringDuration', ringDuration);
  static int getRingDuration() => _preferences?.getInt('ringDuration') as int;

  static Future setSnoozeDuration(int snoozeDuration) async =>
    await _preferences?.setInt('snoozeDuration', snoozeDuration);
  static int getSnoozeDuration() => _preferences?.getInt('snoozeDuration') as int;

  static Future setSnoozeAmount(int snoozeDuration) async =>
    await _preferences?.setInt('snoozeDuration', snoozeDuration);
  static int getSnoozeAmount() => _preferences?.getInt('snoozeDuration') as int;

  static Future setFirstName(String firstName) async =>
    await _preferences?.setString('firstName', firstName);
  static String getFirstName() => _preferences?.get('firstName') as String;

  static Future setLastName(String lastName) async =>
    await _preferences?.setString('lastName', lastName);
  static String getLastName() => _preferences?.get('lastName') as String;

  static Future setDeviceID(String deviceID) async =>
    await _preferences?.setString('deviceID', deviceID);
  static String getDeviceID() => _preferences?.get('deviceID') as String;

  static Future setUserID(String userID) async =>
    await _preferences?.setString('userID', userID);
  static String getUserID() => _preferences?.get('userID') as String;
  
}