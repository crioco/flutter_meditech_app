import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/const/day_of_week.dart';
import 'package:flutter_meditech_app/functions/global_functions.dart';
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
      appBar: MyAppBar(title: 'Edit Pill'),
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
                    Row(
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
                    const Divider(thickness: 1, height: 1,),
                    Column(
                      children: [1,2,3,4,5,6,7].map((day){      
                      bool isChecked = days.contains(day);
                        return Row(
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
                        ],);
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
                  Row(
                    children: [
                      const Text('Alarms:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(icon: const Iconify(Ion.plus, size: 23), onPressed: (){
                        showAddDialog(context, alarmList);
                      })
                    ],
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
                          Row(children: [
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
        title: const Text('Delete Alarm?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                alarmList.removeAt(index);
                Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList(alarmList);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete')
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
              Text('Add Alarm'),
              Divider(thickness: 1, height: 1)
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
               children: [
                 const Text('Time: '),
                 TextButton(child: Text(convertToTwelveHour(intTime)), onPressed: (){
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
                DropdownButton<int>(
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
                          child: Text(value.toString()),
                        );
                      }).toList(),
                        )
              ],)
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  print('Time: ${convertToTwelveHour(intTime)} Dosage: $dosage');
                  alarmList.add({'dosage': dosage, 'time': intTime});
                  Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList(alarmList);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add')
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
              Text('Edit Alarm'),
              Divider(thickness: 1, height: 1)
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
               children: [
                 const Text('Time: '),
                 TextButton(child: Text(convertToTwelveHour(intTime)), onPressed: (){
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
                DropdownButton<int>(
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
                          child: Text(value.toString()),
                        );
                      }).toList(),
                        )
              ],)
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  alarmList.removeAt(index);
                  alarmList.add({'dosage': dosage, 'time': intTime});
                  alarmList.sort((a,b)=> (a['time'] as int).compareTo(b['time'] as int));
                  Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList(alarmList);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Edit')
            ),
          ],
        );},
      );
    });
  }
}



