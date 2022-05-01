import 'package:flutter_meditech_app/model/pill_object.dart';

String convertToTwelveHour(int time) {
  String formattedTime, meridiem;
  var hour = (time / 100).floor();
  var minute = time % 100;

  if (hour >= 12) {
    meridiem = 'PM';
  } else {
    meridiem = 'AM';
  }

  if(hour > 12) hour -= 12;

  if (hour == 0) {
    hour = 12;
  }

  if (minute < 10) {
    formattedTime = '$hour:0$minute $meridiem';
  } else {
    formattedTime = '$hour:$minute $meridiem';
  }
  return formattedTime;
}

  // For Pill Alarm List Sorted by Day of Week
  void mergeMap(Map<int, Map<String, int>> map1, Map<int, Map<String, int>> map2){
    var mergedMap = <int, Map<String, int>> {};
    
    // MERGE TWO MAPS
    for (var map in [map1, map2]) {
      for (var entry in map.entries) {
        // Add an empty `List` to `mergedMap` if the key doesn't already exist
        // and then merge the `List`s.
        (mergedMap[entry.key] ??= {}).addAll(entry.value); 
      }
    }

    // SORT MAP BY ALARM TIME (KEY)
    var sortedMap = Map.fromEntries(mergedMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    map1.clear();
    map1.addAll(sortedMap);
    
    // SORT VALUE (MAP) BY PILL NAME
    for (var valueMap in mergedMap.values){
      var sortMapByTime = Map.fromEntries(valueMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
      valueMap.clear();
      valueMap.addAll(sortMapByTime);
    }
  }

  Map<int, Map<int, Map<String, int>>> getArrangedAlarm(List<Pill> pillList){
    Map<int, Map<int, Map<String, int>>> arrangedAlarms = { 
      1: <int, Map<String, int>>{},
      2: <int, Map<String, int>>{},
      3: <int, Map<String, int>>{},
      4: <int, Map<String, int>>{},
      5: <int, Map<String, int>>{},
      6: <int, Map<String, int>>{},
      7: <int, Map<String, int>>{}
    };

    for (Pill pill in pillList){
      Map<int, Map<String, int>> temp = {};

      var pillName = pill.pillName;
      var alarmList = pill.alarmList;
      var days = pill.days;
      for (Map<String, dynamic> map in alarmList){
        var time = map['time'];
        var dosage = map['dosage'];
        temp[time as int] = {pillName : dosage as int};
      }
    
      // MERGE CREATED MAP INTO arrangeAlarm MAP BY days IN Pill OBJECT
      for (int day in days){
        if (day == 0) day = 7;
        mergeMap(arrangedAlarms[day] as Map<int, Map<String, int>>, temp);
      }
    }

    return arrangedAlarms;
  }
