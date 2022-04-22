import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  Map<int, Map<int, Map<String, int>>> arrangedAlarms = {
    1: <int, Map<String, int>>{},
    2: <int, Map<String, int>>{},
    3: <int, Map<String, int>>{},
    4: <int, Map<String, int>>{},
    5: <int, Map<String, int>>{
      830: {'Melatonin': 1, 'Vitamin C': 2},
      1500: {'Vitamin C': 1},
      2000: {'Melatonin': 3}
    },
    6: <int, Map<String, int>>{},
    7: <int, Map<String, int>>{}
  };

  Map<int, List<Map<String, dynamic>>> alarms = {};
  var timeNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(title: 'Reminder'),
        drawer: MySideMenu(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FutureBuilder<Map<int, List<Map<String, dynamic>>>>(
              future: getAlarmList(timeNow),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<int, List<Map<String, dynamic>>>>
                      map) {
                return (map.hasData)
                    ? Column(
                      children: [
                        Column(
                          children: [
                            Text(DateFormat.EEEE().format(timeNow), style: const TextStyle(fontSize: 30),),
                            Text(DateFormat.yMMMMd().format(timeNow), style: const TextStyle(fontSize: 30),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: map.data?.length,
                              itemBuilder: (context, index) {
                                var time = map.data!.keys.elementAt(index);
                                var hour = (time / 100).floor();
                                String meridiem = (hour >= 12) ? 'PM' : 'AM';
                                if (hour > 12) {
                                  hour -= 12;
                                } else if (hour == 0) {
                                  hour = 12;
                                }
                                var minute = (time % 100).toString().padLeft(2, '0');
                                bool alarmPassed = false;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: ExpansionTileCard(
                                    title: Text('$hour:$minute $meridiem'),
                                    children: [
                                      const Divider(
                                        thickness: 1.0,
                                        height: 1.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                        child: ListView(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          children: (map.data!.values.elementAt(index)).map(
                                            (Map<String, dynamic> map1) {
                                              var pillName = map1['pill_name'];
                                              var dosage = map1['dosage'];
                                              var status = map1['status'];
                                              if (status != '- -') alarmPassed = true;
                                              return Row(
                                                mainAxisAlignment:MainAxisAlignment.spaceAround,
                                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      (alarmPassed) ? Container(
                                        padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(onPressed: (){}, child: const Text('Edit')))
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
                        height:
                            MediaQuery.of(context).size.height - 160,
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
        .where('alarmTime', isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day))
        .where('alarmTime', isLessThan: DateTime(date.year, date.month, date.day).add(const Duration(days: 1)))
        .orderBy('alarmTime', descending: false)
        .get();

    var queryList = query.docs;
    Map<int, List<Map<String, dynamic>>> temp = {};
    if (queryList.isNotEmpty) {
      for (var document in queryList) {
        var data = document.data();
        var isSkipped = data['isSkipped'] as bool;
        var alarmTime = data['alarmTime'].toDate().add(const Duration(hours: 8)) as DateTime;
        var pills = data['pills'] as Map<String, dynamic>;

        List<Map<String, dynamic>> tempList = [];
        for (var index = 0; index < pills.length; index++) {
          Map<String, dynamic> tempPill = {};
          var pillName = pills.keys.elementAt(index);
          var valueMap = pills.values.elementAt(index);
          var dosage = valueMap['dosage'];
          var isTaken = valueMap['isTaken'];
          
          String status;
          if (isTaken) { status = 'Taken';
          } else if (isSkipped) { status = 'Skipped';
          } else { status = 'Missed';
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

    var alarmMap =
        arrangedAlarms[timeNow.weekday] as Map<int, Map<String, int>>;
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

      temp[time] = tempList;
    });

    return temp;
  }
}
