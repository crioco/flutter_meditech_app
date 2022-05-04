import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/functions/global_functions.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:provider/provider.dart';


resetData(String userID, BuildContext context) async {

  if( await getUserDevice(userID, context)){
    getData(context);
  }
}

Future<bool> getUserDevice(String userID, BuildContext context) async{

    DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
    .collection('Users').doc(userID).get();
    var data = query.data();

    var firstName = data!['firstname'];
    var lastName = data['lastname'];
    Provider.of<DataProvider>(context, listen: false).changeUser(userID: userID, firstName: firstName, lastName: lastName);
    await DataSharedPreferences.setUserID(userID);
    await DataSharedPreferences.setFirstName(firstName);
    await DataSharedPreferences.setLastName(lastName);

    var deviceID = data['device'];
    if(deviceID == 'NULL'){
      await DataSharedPreferences.setPillList('');
      await DataSharedPreferences.setRingDuration(0);
      await DataSharedPreferences.setSnoozeDuration(0);
      await DataSharedPreferences.setSnoozeAmount(0);
      await DataSharedPreferences.setDeviceID(deviceID);
      return false;
    } 

    Provider.of<DataProvider>(context, listen: false).changeDeviceID(deviceID);
    await DataSharedPreferences.setDeviceID(deviceID);
    return true;
  }

   getData(BuildContext context) async{
    DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
    .collection('DEVICES').doc(Provider.of<DataProvider>(context, listen: false).deviceID).get();

    var data = query.data();
    var ringDuration = data!['ringDuration'] as int;
    var snoozeDuration = data['snoozeDuration'] as int;
    var snoozeAmount = data['snoozeAmount'] as int;
    var pillSettings = data['pillSettings'].cast<Map<String, dynamic>>();

    List<Pill> pillList = [];

    for (var pill in pillSettings){
      var pillName = pill['pillName'] as String;
      var days = pill['days'].cast<int>();
      var containerSlot = pill['containerSlot'] as int;
      var alarmListObj = pill['alarmList'].cast<Map<String, dynamic>>();

      List<Map<String,dynamic>> alarmList = [];
      for (var alarm in alarmListObj){
        alarmList.add({'dosage': alarm['dosage'] as int, 'time': alarm['time'] as int});
      }

      pillList.add(Pill(pillName: pillName, days: days, containerSlot: containerSlot, alarmList: alarmList));
    }

    Provider.of<DataProvider>(context, listen: false).changeAlarmSettings(snoozeDuration: snoozeDuration, snoozeAmount: snoozeAmount, ringDuration: ringDuration);
    Provider.of<DataProvider>(context, listen: false).changePillList(pillList);

    var arrangedAlarms = getArrangedAlarm(pillList);
    Provider.of<DataProvider>(context, listen: false).changeArrangedAlarms(arrangedAlarms);

    String jsonPillList = jsonEncode(pillList);

    await DataSharedPreferences.setPillList(jsonPillList);
    await DataSharedPreferences.setRingDuration(ringDuration);
    await DataSharedPreferences.setSnoozeDuration(snoozeDuration);
    await DataSharedPreferences.setSnoozeAmount(snoozeDuration);

  }