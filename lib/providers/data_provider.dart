import 'package:flutter/widgets.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';

class DataProvider extends ChangeNotifier{
  
  String deviceID;
  String userID;
  String firstName;
  String lastName;

  List<Pill> pillList;
  int ringDuration;
  int snoozeAmount;
  int snoozeDuration;

  Map<int, Map<int, Map<String, int>>> arrangedAlarms;
 
  DataProvider({
    this.deviceID = '',
    this.userID = '',
    this.firstName = '',
    this.lastName= '',
    this.pillList = const [],
    this.ringDuration = 0,
    this.snoozeDuration = 0,
    this.snoozeAmount = 0,
    this.arrangedAlarms = const {},
  });

  void changePillList(List<Pill> pillList){
    this.pillList = pillList;
    // this.pillList.clear();
    // this.pillList.addAll(pillList);
    notifyListeners();
  }

  void changeDeviceID(String deviceID){
    this.deviceID = deviceID;
    notifyListeners();
  }

  void changeUser({required String userID, required String firstName, required String lastName}){
    this.userID = userID;
    this.firstName = firstName;
    this.lastName = lastName;
    notifyListeners();
  }

  void changeAlarmSettings({required int snoozeDuration, required int snoozeAmount, required int ringDuration}){
    this.ringDuration = ringDuration;
    this.snoozeDuration = snoozeDuration;
    this.snoozeAmount = snoozeAmount;
    notifyListeners();
  }

  void changeArrangedAlarms(Map<int, Map<int, Map<String, int>>> arrangedAlarms){
    this.arrangedAlarms = arrangedAlarms;
    // this.arrangedAlarms.clear();
    // this.arrangedAlarms.addAll(arrangedAlarms);
    notifyListeners();
  }
}