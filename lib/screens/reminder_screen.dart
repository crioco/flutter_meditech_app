import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_meditech_app/widgets/reminder_dialog.dart';
import 'package:provider/provider.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  // Map<int, Map<int, Map<String, int>>> arrangedAlarms = {
  //   1: <int, Map<String, int>>{       
  //     830: {'Melatonin': 1, 'Vitamin C': 2},
  //     1500: {'Vitamin C': 1},
  //     2000: {'Melatonin': 3}
  //     },
  //   2: <int, Map<String, int>>{
  //     943: {'Melatonin': 1, 'Vitamin C': 2},
  //     948: {'Vitamin C': 1},
  //     2000: {'Melatonin': 3}
  //   },
  //   3: <int, Map<String, int>>{       
  //     // 947: {'Melatonin': 1, 'Vitamin C': 2},
  //     // 1500: {'Vitamin C': 1},
  //     // 2000: {'Melatonin': 3}
  //     },
  //   4: <int, Map<String, int>>{},
  //   5: <int, Map<String, int>>{
  //     // 944: {'Melatonin': 1, 'Vitamin C': 2},
  //     // 1500: {'Vitamin C': 1},
  //     // 2000: {'Melatonin': 3}
  //   },
  //   6: <int, Map<String, int>>{},
  //   7: <int, Map<String, int>>{
  //     //  944: {'Melatonin': 1, 'Vitamin C': 2},
  //     // 1500: {'Vitamin C': 1},
  //     // 2000: {'Melatonin': 3}
  //   }
  // };

  Map<int, Map<int, Map<String, int>>> arrangedAlarms = {};
  var timeNow = DateTime.now();
  DateTime displayTime = DateTime.now();
  bool alarmListEmpty = true;

  @override
  Widget build(BuildContext context) {
    arrangedAlarms = Provider.of<DataProvider>(context).arrangedAlarms;

    return Scaffold(
      appBar: const MyAppBar(title: 'Reminder'),
      drawer: const MySideMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: FutureBuilder<Map<int, List<Map<String, dynamic>>>>(
            future: getAlarmList(displayTime),
            builder: (BuildContext context, AsyncSnapshot<Map<int, List<Map<String, dynamic>>>> map) {
              return (map.hasData)
                  ? Column(
                      children: [
                        GestureDetector(
                          child: Column(
                            children: [
                              Text(
                                DateFormat.EEEE().format(displayTime),
                                style: const TextStyle(fontSize: 25),
                              ),
                              Text(
                                DateFormat.yMMMMd().format(displayTime),
                                style: const TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                          onTap: (){
                            DatePicker.showDatePicker(context,
                              currentTime: displayTime,
                              showTitleActions: true,
                              minTime: timeNow.subtract(const Duration(days: 6)),
                              maxTime: timeNow.add(const Duration(days: 6)),
                              onConfirm: (date) {
                                setState(() {
                                displayTime = date;
                                });
                              },);
                          },
                        ),
                        (alarmListEmpty) ?
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 210,
                          child: const Center(
                              child: SizedBox(
                            height: 70,
                            width: 70,
                            child: Text('No Alarm'),
                          )),
                        )  
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: map.data?.length,
                            itemBuilder: (context, index) {
                              var time = map.data!.keys.elementAt(index);
                              var hour = (time / 100).floor();
                              var minute =(time % 100).toString().padLeft(2, '0');
                              var docID = '${displayTime.year.toString()}${displayTime.month.toString().padLeft(2, '0')}${displayTime.day.toString().padLeft(2, '0')}-${hour.toString().padLeft(2, '0')}$minute';
                              String meridiem = (hour >= 12) ? 'PM' : 'AM';
                              if (hour > 12) {
                                hour -= 12;
                              } else if (hour == 0) {
                                hour = 12;
                              }
                              var mapItem = map.data!.values.elementAt(index);
                              var formattedTime = '$hour:$minute $meridiem';
                              bool alarmPassed = false;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: ExpansionTileCard(
                                  title: Text(formattedTime),
                                  children: [
                                    const Divider(
                                      thickness: 1.0,
                                      height: 1.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      child: ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: (map.data!.values.elementAt(index)).map(
                                          (Map<String, dynamic> map1) {
                                            var pillName = map1['pill_name'];
                                            var dosage = map1['dosage'];
                                            var status = map1['status'];
                                            if (status != '- -') { alarmPassed = true;}
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(dosage.toString()),
                                                Text(pillName),
                                                Text(status),
                                              ],
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                    (alarmPassed && displayTime.isAfter(timeNow.subtract(const Duration(days: 6))))
                                        ? Container(
                                            padding: const EdgeInsets.fromLTRB( 0, 10, 20, 10),
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              child: const Text('Edit'),
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return ReminderDialog(mapItem: mapItem, docID: docID, time: formattedTime,);
                                                  }
                                                );
                                                setState(() {
                                                  
                                                });
                                              },
                                            ))
                                        : Container()
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 160,
                      child: const Center(
                          child: SizedBox(
                              height: 70,
                              width: 70,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                              ))));
            },
          ),
        ),
      ));
  }

  Future<Map<int, List<Map<String, dynamic>>>> getAlarmList(DateTime date) async {
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection('DEVICE001')
        .where('alarmTime',
            isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day))
        .where('alarmTime',
            isLessThan: DateTime(date.year, date.month, date.day).add(const Duration(days: 1)))
        .orderBy('alarmTime', descending: false)
        .get();
    var queryList = query.docs;
    Map<int, List<Map<String, dynamic>>> temp = {};
    if (queryList.isNotEmpty) {
      for (var document in queryList) {
        var data = document.data();
        var isMissed = data['isMissed'] as bool;
        var alarmTime = data['alarmTime'].toDate()
            as DateTime;
        var pills = data['pills'] as Map<String, dynamic>;

        List<Map<String, dynamic>> tempList = [];
        for (var index = 0; index < pills.length; index++) {
          Map<String, dynamic> tempPill = {};
          var pillName = pills.keys.elementAt(index);
          var valueMap = pills.values.elementAt(index);
          var dosage = valueMap['dosage'];
          var isTaken = valueMap['isTaken'];

          String status;
          if (isTaken) {
            status = 'Taken';
          } else if (isMissed) {
            status = 'Missed';
          } else {
            status = 'Skipped';
          }

          tempPill['pill_name'] = pillName;
          tempPill['dosage'] = dosage;
          tempPill['status'] = status;

          tempList.add(tempPill);
        }
        var time = alarmTime.hour * 100 + alarmTime.minute;
        temp[time] = tempList;
      }
    }

    var alarmMap = arrangedAlarms[date.weekday] as Map<int, Map<String, int>>;
    alarmMap.forEach((key, value) {
      var time = key;
      var valueMap = value;
      List<Map<String, dynamic>> tempList = [];
      valueMap.forEach((key, value) {
        Map<String, dynamic> tempMap = {};
        var pillName = key;
        var dosage = value;

        tempMap['pill_name'] = pillName;
        tempMap['dosage'] = dosage;
        tempMap['status'] = '- -';

        tempList.add(tempMap);
      });

      temp.putIfAbsent(time, () => tempList);
    });
    if (temp.isEmpty) {
      alarmListEmpty = true;
    } else {
      alarmListEmpty = false;
    }
    return temp;
  }
}
