import 'package:cloud_firestore/cloud_firestore.dart';

class Pill {
  String pillName;
  List<int> days;
  List<Map<String, dynamic>> alarmList;
  int containerSlot;

  Pill({
    required this.pillName,
    required this.days,
    required this.alarmList,
    required this.containerSlot,
  });

  Map toJson() => {
    'pillName' : pillName,
    'days' : days,
    'alarmList' : alarmList,
    'containerSlot' : containerSlot,
  };

  factory Pill.fromJson(Map<String, dynamic> jsonData){
    return Pill(
      pillName: jsonData['pillName'] as String,
      days: jsonData['days'].cast<int>(),
      containerSlot: jsonData['containerSlot'],
      alarmList: jsonData['alarmList'].cast<Map<String, dynamic>>()
    );
  }

  factory Pill.fromSnapshot(DocumentSnapshot docSnapshot){
    return Pill(
      pillName: docSnapshot.get('pillName') as String,
      days: docSnapshot.get('days') as List<int>,
      containerSlot: docSnapshot.get('containerSlot') as int,
      alarmList: docSnapshot.get('alarmList') as List<Map<String, dynamic>>
    );
  }
}