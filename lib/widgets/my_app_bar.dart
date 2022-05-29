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
            // var pill = Provider.of<SelectedPillProvider>(context, listen: false).pill;
            // Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedPillName(pill.pillName);
            // Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedContainerSlot(pill.containerSlot);
            // Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedDays(pill.days);
            // Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList(pill.alarmList);
            // Navigator.of(context).pop();
        })

        // : (title == 'Device Settings')
        // ? IconButton( 
        //   icon:const Iconify(Ion.md_arrow_back, color: Colors.white, size: 30,),
        //   onPressed: (){
        //     Provider.of<DataProvider>(context, listen: false).changeRingDuration(DataSharedPreferences.getRingDuration());
        //     Provider.of<DataProvider>(context, listen: false).changeSnoozeDuration(DataSharedPreferences.getSnoozeDuration());
        //     Provider.of<DataProvider>(context, listen: false).changeSnoozeAmount(DataSharedPreferences.getSnoozeAmount());
        //     Provider.of<DataProvider>(context, listen: false).changeWiFiPassword(DataSharedPreferences.getWiFiPassword());
        //      Provider.of<DataProvider>(context, listen: false).changeWiFiSSID(DataSharedPreferences.getWiFiSSID());

        //     Navigator.of(context).pop();
        // })

        : IconButton(
        icon:const Iconify(Ion.reorder_three_sharp, color: Colors.white, size: 30,),
          onPressed: (){
            Scaffold.of(context).openDrawer();
        }),
      actions: 
      [
        Container(),
      ]
    );
  }

  // Future addMonitorList(String otherID, BuildContext context) async{
  //   var userID = Provider.of<DataProvider>(context, listen: false).userID;

  //   DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
  //   .collection('Users').doc(otherID).get();
  //   List<String> monitorList;
  //   if(query.exists){
  //     if (query.data()!['monitorList'] != null){
  //       monitorList = query.data()!['monitorList'];
  //       monitorList.add(otherID);
  //     } else {
  //        monitorList = [otherID];
  //     }
  //     print(monitorList.toString());

  //     FirebaseFirestore.instance.collection('Users').doc(userID).update({'monitorList': monitorList})
  //     .then((value) async{
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Added to Monitor List'),
  //       backgroundColor: Color.fromARGB(255, 74, 204, 79),
  //       ));
  //     })
  //     .catchError((error){
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Failed to Add to Monitor List'),
  //       backgroundColor: Color.fromARGB(255, 196, 69, 69),
  //       ));
  //     });
     
  //   }
  // }

  @override
  final Size preferredSize;
}
