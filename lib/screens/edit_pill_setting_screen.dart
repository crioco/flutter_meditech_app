import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/const/day_of_week.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/functions/global_functions.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/providers/selected_pill_provider.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:provider/provider.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';


class EditPillSettingScreen extends StatefulWidget {
  const EditPillSettingScreen({ Key? key }) : super(key: key);

  @override
  State<EditPillSettingScreen> createState() => _EditPillSettingScreenState();
}

class _EditPillSettingScreenState extends State<EditPillSettingScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var pillList = List.of(Provider.of<DataProvider>(context).pillList);
    var index = Provider.of<SelectedPillProvider>(context).pillIndex;
    var pillName = Provider.of<SelectedPillProvider>(context).pillName;
    var containerSlot = Provider.of<SelectedPillProvider>(context).containerSlot;
    var initialSlot = Provider.of<SelectedPillProvider>(context).initialSlot;
    var days = List.of(Provider.of<SelectedPillProvider>(context).days);
    var alarmList = List.of(Provider.of<SelectedPillProvider>(context).alarmList);
    bool isDaysSeries = true;
    List<int> availableSlots = [];
    List<int> takenSlots = [];
   
    if (days.length <= 2){
      isDaysSeries = false;
    } else{
      for (var index = 0; index < days.length - 1; index++){
        if ((days[index] + 1) != days[index + 1]) isDaysSeries = false;
      } 
    }

    for (var pill in pillList) {
      takenSlots.add(pill.containerSlot);
    }

    for (var index = 1; index <= 5; index++){
      if(!takenSlots.contains(index) || index == initialSlot){
        availableSlots.add(index);
      }
    } 

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Edit Pill'),
        actions: [
          IconButton( icon: const Iconify(Ion.md_checkmark, color: Colors.white), onPressed: () async{
            await editPillSettings(context);
            Navigator.of(context).pop();
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
            // PILL NAME
             Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    const Text(
                      'Pill Name:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Expanded(child: SizedBox(),),
                    SizedBox(
                      height: 45, width: 200,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        initialValue: pillName,
                        // controller: pillNameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Pill Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text){
                           Provider.of<SelectedPillProvider>(context, listen: false)
                          .changeSelectedPillName(text);
                        },                      
                      )
                    )
                  ],
              )),
              // CONTAINER SLOT
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                  children: [
                    const Text(
                      'Container Slot:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Expanded(child: SizedBox(),),
                    DropdownButton<int>(
                      value: containerSlot,
                      elevation: 8,
                      // style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      onChanged: (value) {
                        setState(() {
                          Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedContainerSlot(value as int);          
                        });
                      },
                      items: availableSlots
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                        ),
                  ],
              )),
              // DAYS
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
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
                    const Divider(thickness: 1, height: 1,),
                    const SizedBox(height: 20),
                    Column(
                      children: [1,2,3,4,5,6,7].map((day){      
                      bool isChecked = days.contains(day);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                            Text(dayOfWeekFull[day] as String, style: const TextStyle(fontSize: 16)),
                            const Spacer(),
                            SizedBox(
                              height: 26,
                              width: 26,
                              child: Checkbox(value: isChecked, 
                              onChanged: (value){
                                setState(() {
                                  // isChecked = value as bool;
                                  // print(value);                          
                                    if(value as bool){
                                      days.add(day);
                                    } else if(days.length > 1){days.remove(day);}
                                    days.sort((a,b) => a.compareTo(b));
                                    Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedDays(days);
                                });
                              }),
                            )
                          ],),
                        );
                      }).toList(),
                    ),
                    //List view builder of days
                  ],
                ),
              ),
            // ALARM LIST
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        const Text('Alarms:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(icon: const Iconify(Ion.plus, size: 23), onPressed: (){
                          showAddDialog(context, alarmList);
                        })
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, height: 1,),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: alarmList.length,
                    itemBuilder: (context, index){
                      var alarm = alarmList[index];
                      var dosage = alarm['dosage'];
                      var time = alarm['time'];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(children: [
                              Text(convertToTwelveHour(time), style: const TextStyle(fontSize: 16)),
                              Container(
                                width: 20,
                                alignment: Alignment.center, 
                                child: const Text('-')),
                              (dosage > 1)
                              ? Text('${dosage.toString()} Pills', style: const TextStyle(fontSize: 16))
                              :  Text('${dosage.toString()} Pill', style: const TextStyle(fontSize: 16)),
                              const Spacer(),
                              IconButton(icon: const Iconify(Ion.edit, size: 23,), onPressed: (){
                                showEditDialog(context, alarmList, index);
                              }),
                              IconButton(icon: const Iconify(Ion.trash_sharp, size: 23,), onPressed: (){
                                showDeleteDialog(context, alarmList, index);
                              }),
                            ]),
                          ),                    
                          const Divider(thickness: 1, height: 1,)
                        ],
                      );
                    }),
              ]),
            ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context, List<Map<String,dynamic>> alarmList, int index){
    showDialog(context: context,  builder: (BuildContext context){
      return AlertDialog(
        content: const SizedBox(
          width: double.maxFinite,
        ),
        title: const Center(child: Text('Delete Alarm?', style: TextStyle(fontSize: 25))),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.grey
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL')
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.redAccent
                ),
                onPressed: () {
                  setState(() {
                    alarmList.removeAt(index);
                    Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList(alarmList);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('DELETE')
              ),
            ],
          ),
        ],
      );
    });
  }

  void showAddDialog(BuildContext context, List<Map<String,dynamic>> alarmList){
    var _timeNow = TimeOfDay.now();
    var intTime = _timeNow.hour*100 + _timeNow.minute;
    var dosage = 1;
    showDialog(context: context,  builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
        return AlertDialog(
          title: Column(
            children: const [
              Text('Add Alarm', style: TextStyle(fontSize: 25)),
              Divider(thickness: 1, height: 1)
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                 children: [
                   const Text('Time: ', style: TextStyle(fontSize: 18)),
                   const Spacer(),
                   TextButton(child: Text(convertToTwelveHour(intTime), style: const TextStyle(fontSize: 18)), onPressed: (){
                    Navigator.of(context).push(showPicker(
                      value: _timeNow,
                      context: context,
                      onChange: (time){
                        setState(() {
                          _timeNow = time;
                          intTime = _timeNow.hour*100 + _timeNow.minute;
                        });
                      }));
                   })
                 ],
                ),
                Row(children: [
                  const Text('Dosage', style: TextStyle(fontSize: 18)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: 75,
                    child: DropdownButton<int>(
                          isExpanded: true,
                          value: dosage,
                          elevation: 8,
                          // style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          onChanged: (value) {
                            setState(() {
                             dosage = value as int;               
                            });
                          },
                          items: [1,2,3,4]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Center(child: Text(value.toString())),
                            );
                          }).toList(),
                            ),
                  )
                ],)
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      primary: Colors.grey
                   ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL')
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    primary: Colors.blueAccent
                  ),
                  onPressed: () {
                    setState(() {
                      print('Time: ${convertToTwelveHour(intTime)} Dosage: $dosage');
                      alarmList.add({'dosage': dosage, 'time': intTime});
                      Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList(alarmList);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('ADD')
                ),
              ],
            ),
          ],
        );},
      );
    });
  }

  void showEditDialog(BuildContext context, List<Map<String,dynamic>> alarmList, int index){
    var intTime = alarmList[index]['time'];
    var dosage =  alarmList[index]['dosage'];
    var hour = (intTime/100).floor();
    var minute = intTime%100;
    var _timeNow = TimeOfDay(hour: hour, minute: minute);

    showDialog(context: context,  builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
        return AlertDialog(
          title: Column(
            children: const [
              Text('Edit Alarm', style: TextStyle(fontSize: 25)),
              Divider(thickness: 1, height: 1)
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                 children: [
                   const Text('Time: ', style: TextStyle(fontSize: 18)),
                   const Spacer(),
                   TextButton(child: Text(convertToTwelveHour(intTime), style: const TextStyle(fontSize: 18)), onPressed: (){
                    Navigator.of(context).push(showPicker(
                      value: _timeNow,
                      context: context,
                      onChange: (time){
                        setState(() {
                          _timeNow = time;
                          intTime = _timeNow.hour*100 + _timeNow.minute;
                        });
                      }));
                   })
                 ],
                ),
                Row(children: [
                  const Text('Dosage'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: 75,
                    child: DropdownButton<int>(
                      isExpanded: true,
                      alignment: Alignment.center,
                      value: dosage,
                      elevation: 8,
                      // style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      onChanged: (value) {
                        setState(() {
                        dosage = value as int;               
                        });
                      },
                      items: [1,2,3,4]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Center(child: Text(value.toString())),
                        );
                      }).toList(),
                        ),
                  )
                ],)
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(110, 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    primary: Colors.grey
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL')
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(110, 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    primary: Colors.blueAccent
                  ),
                  onPressed: () {
                    setState(() {
                      alarmList.removeAt(index);
                      alarmList.add({'dosage': dosage, 'time': intTime});
                      alarmList.sort((a,b)=> (a['time'] as int).compareTo(b['time'] as int));
                      Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList(alarmList);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('EDIT')
                ),
              ],
            ),
          ],
        );},
      );
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

    Provider.of<SelectedPillProvider>(context, listen:false).changeSelectedInitialSlot(containerSlot);
    Provider.of<SelectedPillProvider>(context, listen:false).changeSelectedPill(pillList.elementAt(index));
    Provider.of<DataProvider>(context, listen:false).changePillList(pillList);
    
    // List<Map<String, dynamic>> pillSettings = pillList.map((pill)=> pill.toMap()).toList();

    // var deviceID = Provider.of<DataProvider>(context, listen: false).deviceID;
    // var docRef =  FirebaseFirestore.instance.collection('DEVICES').doc(deviceID);
    // await docRef.update({'pillSettings': pillSettings})
    // .then((value) async{
    //   Provider.of<SelectedPillProvider>(context, listen:false).changeSelectedInitialSlot(containerSlot);
    //   Provider.of<SelectedPillProvider>(context, listen:false).changeSelectedPill(pillList.elementAt(index));
    //   Provider.of<DataProvider>(context, listen:false).changePillList(pillList);
    //   String jsonPillList = jsonEncode(pillList);
    //   await DataSharedPreferences.setPillList(jsonPillList);

    //   var arrangedAlarms = getArrangedAlarm(pillList);
    //   Provider.of<DataProvider>(context, listen: false).changeArrangedAlarms(arrangedAlarms);
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //   content: Text('Pill Settings Has Been Updated'),
    //   backgroundColor: Color.fromARGB(255, 74, 204, 79),
    //   ));
    // })
    // .catchError((error){
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //   content: Text('Failed to Update Pill Settings'),
    //   backgroundColor: Color.fromARGB(255, 196, 69, 69),
    //   ));
    // });
  }



