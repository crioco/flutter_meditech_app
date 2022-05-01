import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/const/container_maps.dart';
import 'package:flutter_meditech_app/const/day_of_week.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/functions/global_functions.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/providers/selected_pill_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:provider/provider.dart';

class PillSettingDrawer extends StatelessWidget {
  const PillSettingDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pill = Provider.of<SelectedPillProvider>(context).pill;
    var pillName = pill.pillName;
    var containerSlot = pill.containerSlot;
    var days = pill.days;
    var alarmList = pill.alarmList;
    bool isDaysSeries = true;

    if (days.length <= 2){
      isDaysSeries = false;
    }else{
      for (var index = 0; index < days.length - 1; index++){
        if ((days[index] + 1) != days[index + 1]) isDaysSeries = false;
      } 
    }

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 10),
        child: Column(
          children: [
            Image.asset(containerImageMap[containerSlot]!),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: [
                          const Text(
                            'Pill Name:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Expanded(child: SizedBox(),),
                          Text(
                            pillName,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                    )),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                        children: [
                          const Text(
                            'Container Slot:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Expanded(child: SizedBox(),),
                          Text(
                            containerSlot.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                    )),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: [
                          const Text('Days:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          (days.length < 7)
                              ? (isDaysSeries) 
                                ? Row(
                                  children: [
                                    Text(dayOfWeek[days.first]!, style: const TextStyle(fontSize: 16)),
                                    Container(width: 30, alignment: Alignment.center, child: const Text('to', style: TextStyle(fontSize: 16))),
                                    Text(dayOfWeek[days.last]!, style: const TextStyle(fontSize: 16)),
                                  ],)
                                
                                : Row(
                                    children: days.map((day) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2),
                                        child: Text('${dayOfWeek[day]!},', style: const TextStyle(fontSize: 16)),
                                      );
                                    }).toList(),
                                  )
                              : const Text('Every Day', style: TextStyle(fontSize: 16))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: [
                          const Text('Alarms:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const Expanded(child: SizedBox()),
                          Column(
                            children: alarmList.map((alarm){
                              var dosage = alarm['dosage'];
                              var time = alarm['time'];
                              return Row(children: [
                                Text(convertToTwelveHour(time), style: const TextStyle(fontSize: 16)),
                                Container(
                                  width: 20,
                                  alignment: Alignment.center, 
                                  child: const Text('-')),
                                (dosage > 1)
                                ? Text('${dosage.toString()} Pills', style: const TextStyle(fontSize: 16))
                                :  Text('${dosage.toString()} Pill', style: const TextStyle(fontSize: 16))
                              ],);
                            }).toList(),
                          )
                      ]),
                    ),
                    // const Spacer(),                   
                  ]),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(child: const Text('Edit', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.blueAccent
                ),
                onPressed: (){              
                  Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedPillName(pillName);
                  Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedContainerSlot(containerSlot);
                  Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedInitialSlot(containerSlot);
                  Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedDays(days);
                  Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList(alarmList);

                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, EditPillSettingScreenRoute);
                }),
                ElevatedButton(child: const Text('Delete', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.redAccent
                ),
                onPressed: () async{
                  showDeleteDialog(context);
                })
              ],
            )
          ],
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context){
    showDialog(context: context,  builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Delete Pill Setting?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () async{
              await updateData(context);
              Navigator.of(context).pop();
            },
            child: const Text('Delete')
          ),
        ],
      );
    });
  }

  Future updateData(BuildContext context) async{
    var pillList = List.of(Provider.of<DataProvider>(context, listen: false).pillList);
    var index = Provider.of<SelectedPillProvider>(context, listen: false).pillIndex;

    pillList.removeAt(index);

    List<Map<String, dynamic>> pillSettings = pillList.map((pill)=> pill.toMap()).toList();

    var deviceID = Provider.of<DataProvider>(context, listen: false).deviceID;
    var docRef =  FirebaseFirestore.instance.collection('DEVICES').doc(deviceID);
    await docRef.update({'pillSettings': pillSettings})
    .then((value) async{
      Provider.of<SelectedPillProvider>(context, listen:false).changeSelectedPill(pillList.elementAt(index));
      Provider.of<DataProvider>(context, listen:false).changePillList(pillList);
      String jsonPillList = jsonEncode(pillList);
      await DataSharedPreferences.setPillList(jsonPillList);

      var arrangedAlarms = getArrangedAlarm(pillList);
      Provider.of<DataProvider>(context, listen: false).changeArrangedAlarms(arrangedAlarms);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Pill has been removed from Pill Settings'),
      backgroundColor: Color.fromARGB(255, 74, 204, 79),
      ));
    })
    .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Failed to remove Pill from Pill Settings'),
      backgroundColor: Color.fromARGB(255, 196, 69, 69),
      ));
    });
    
    Provider.of<DataProvider>(context, listen: false).changePillList(pillList);
    Navigator.of(context).pop();
  }
}
