import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/functions/global_functions.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/providers/selected_pill_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({
    Key? key,
    required this.title,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  }) : super(key: key);
  final String title;
  String deviceID = DataSharedPreferences.getDeviceID();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: (title == 'Add Pill' || title == 'Edit Pill') 
        ? IconButton( 
          icon:const Iconify(Ion.md_close, color: Colors.white),
          onPressed: (){
            // Change values back to unchanged values
            var pill = Provider.of<SelectedPillProvider>(context, listen: false).pill;
            Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedPillName(pill.pillName);
            Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedContainerSlot(pill.containerSlot);
            Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedDays(pill.days);
            Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList(pill.alarmList);
            Navigator.of(context).pop();
        })

        : (title == 'Device Settings')
        ? IconButton( 
          icon:const Iconify(Ion.md_arrow_back, color: Colors.white, size: 30,),
          onPressed: (){
            Provider.of<DataProvider>(context, listen: false).changeRingDuration(DataSharedPreferences.getRingDuration());
            Provider.of<DataProvider>(context, listen: false).changeSnoozeDuration(DataSharedPreferences.getSnoozeDuration());
            Provider.of<DataProvider>(context, listen: false).changeSnoozeAmount(DataSharedPreferences.getSnoozeAmount());

            Navigator.of(context).pop();
        })

        : IconButton( 
        icon:const Iconify(Ion.reorder_three_sharp, color: Colors.white, size: 30,),
          onPressed: (){
            Scaffold.of(context).openDrawer();
        }),
      
      actions: (title == 'Pill Settings' && deviceID != 'NULL') 
      ? [
        IconButton( icon: const Iconify(Ion.settings_sharp, color: Colors.white), onPressed: (){
          Navigator.pushNamed(context, DeviceSettingsScreenRoute);
        }),
      ]
      : (title == 'Edit Pill') 
      ? [
        IconButton( icon: const Iconify(Ion.md_checkmark, color: Colors.white), onPressed: () async{
          
          await editPillSettings(context);
          Navigator.of(context).pop();
          
        }),
      ]
      : (title == 'Add Pill')
      ? [
        IconButton( icon: const Iconify(Ion.md_checkmark, color: Colors.white), onPressed: () async{
          await addPillSettings(context);
          Navigator.of(context).pop();
        }),
      ]
      : (title == 'Monitoring')
      ? [
        IconButton( icon: const Iconify(Ion.md_add, color: Colors.white), onPressed: () async{
         await Navigator.pushNamed(context, QRScanScreenRoute);
       
         var qrResult = Provider.of<DataProvider>(context, listen: false).qrResult;
         addMonitorList(qrResult, context);
        }),
      ]
      : [
        Container(),
      ]
    );
  }

  Future addMonitorList(String otherID, BuildContext context) async{
    var userID = Provider.of<DataProvider>(context, listen: false).userID;

    DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
    .collection('Users').doc(otherID).get();
    List<String> monitorList;
    if(query.exists){
      if (query.data()!['monitorList'] != null){
        monitorList = query.data()!['monitorList'];
        monitorList.add(otherID);
      } else {
         monitorList = [otherID];
      }
      print(monitorList.toString());

      FirebaseFirestore.instance.collection('Users').doc(userID).update({'monitorList': monitorList})
      .then((value) async{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added to Monitor List'),
        backgroundColor: Color.fromARGB(255, 74, 204, 79),
        ));
      })
      .catchError((error){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to Add to Monitor List'),
        backgroundColor: Color.fromARGB(255, 196, 69, 69),
        ));
      });
     
    }
    
  }

  Future editPillSettings(BuildContext context) async {
    var pillName = Provider.of<SelectedPillProvider>(context, listen: false).pillName;
    var containerSlot = Provider.of<SelectedPillProvider>(context, listen: false).containerSlot;
    var days = Provider.of<SelectedPillProvider>(context, listen: false).days;
    var alarmList = Provider.of<SelectedPillProvider>(context, listen: false).alarmList;
    var index = Provider.of<SelectedPillProvider>(context, listen: false).pillIndex;
    var pillList = List.of(Provider.of<DataProvider>(context, listen:false).pillList);

    pillList.removeAt(index);
    pillList.add(Pill(pillName: pillName, days: days, alarmList: alarmList, containerSlot: containerSlot));
    pillList.sort((a,b)=>a.containerSlot.compareTo(b.containerSlot));
    
    List<Map<String, dynamic>> pillSettings = pillList.map((pill)=> pill.toMap()).toList();

    var deviceID = Provider.of<DataProvider>(context, listen: false).deviceID;
    var docRef =  FirebaseFirestore.instance.collection('DEVICES').doc(deviceID);
    await docRef.update({'pillSettings': pillSettings})
    .then((value) async{
      Provider.of<SelectedPillProvider>(context, listen:false).changeSelectedInitialSlot(containerSlot);
      Provider.of<SelectedPillProvider>(context, listen:false).changeSelectedPill(pillList.elementAt(index));
      Provider.of<DataProvider>(context, listen:false).changePillList(pillList);
      String jsonPillList = jsonEncode(pillList);
      await DataSharedPreferences.setPillList(jsonPillList);

      var arrangedAlarms = getArrangedAlarm(pillList);
      Provider.of<DataProvider>(context, listen: false).changeArrangedAlarms(arrangedAlarms);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Pill Settings Has Been Updated'),
      backgroundColor: Color.fromARGB(255, 74, 204, 79),
      ));
    })
    .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Failed to Update Pill Settings'),
      backgroundColor: Color.fromARGB(255, 196, 69, 69),
      ));
    });
  }

  Future addPillSettings(BuildContext context) async {
    var pillName = Provider.of<SelectedPillProvider>(context, listen: false).pillName;
    var containerSlot = Provider.of<SelectedPillProvider>(context, listen: false).initialAvailSlot;
    var days = Provider.of<SelectedPillProvider>(context, listen: false).days;
    var alarmList = Provider.of<SelectedPillProvider>(context, listen: false).alarmList;
    var pillList = List.of(Provider.of<DataProvider>(context, listen:false).pillList);

    pillList.add(Pill(pillName: pillName, days: days, alarmList: alarmList, containerSlot: containerSlot));
    pillList.sort((a,b)=>a.containerSlot.compareTo(b.containerSlot));
    
    List<Map<String, dynamic>> pillSettings = pillList.map((pill)=> pill.toMap()).toList();

    var deviceID = Provider.of<DataProvider>(context, listen: false).deviceID;
    var docRef =  FirebaseFirestore.instance.collection('DEVICES').doc(deviceID);
    await docRef.update({'pillSettings': pillSettings})
    .then((value) async{
      Provider.of<DataProvider>(context, listen:false).changePillList(pillList);
      String jsonPillList = jsonEncode(pillList);
      await DataSharedPreferences.setPillList(jsonPillList);

      var arrangedAlarms = getArrangedAlarm(pillList);
      Provider.of<DataProvider>(context, listen: false).changeArrangedAlarms(arrangedAlarms);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Pill Settings Has Been Updated'),
      backgroundColor: Color.fromARGB(255, 74, 204, 79),
      ));
    })
    .catchError((error){
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Failed to Update Pill Settings'),
      backgroundColor: Color.fromARGB(255, 196, 69, 69),
      ));
    });
  }

  @override
  final Size preferredSize;
}
