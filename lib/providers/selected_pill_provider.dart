import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';

class SelectedPillProvider extends ChangeNotifier{

  Pill pill;
  int pillIndex;

  String pillName;
  int containerSlot;
  int initialSlot;
  List<int> days;
  List<Map<String, dynamic>> alarmList;
 
  SelectedPillProvider({
    this.pill = const Pill(pillName: '', containerSlot: 0, days: [], alarmList: []),
    this.pillIndex = 0,
    this.pillName = '',
    this.containerSlot = 0,
    this.initialSlot = 0,
    this.days = const [],
    this.alarmList = const []
  });

  void changeSelectedPill(Pill pill){
    this.pill = pill;
    notifyListeners();
  }

  void changeSelectedPillIndex(int index){
    pillIndex = index;
    notifyListeners();
  }

  void changeSelectedPillName(String pillName){
    this.pillName = pillName;
    notifyListeners();
  }

  void changeSelectedContainerSlot(int containerSlot){
    this.containerSlot = containerSlot;
    notifyListeners();
  }

  void changeSelectedInitialSlot(int initialSlot){
    this.initialSlot = initialSlot;
    notifyListeners();
  }

  void changeSelectedDays(List<int> days){
    this.days = days;
    notifyListeners();
  }

  void changeSelectedAlarmList(List<Map<String, dynamic>> alarmList){
    this.alarmList = alarmList;
    notifyListeners();
  }



}