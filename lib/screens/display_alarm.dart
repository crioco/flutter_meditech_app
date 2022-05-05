import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import '../model/alarm_helper.dart';
import '../model/alarm_info.dart';
import '../model/schedule_Alarm.dart';
import '../widgets/add_Alarm.dart';



class DisplayAlarm extends StatefulWidget {
  const DisplayAlarm({Key? key}) : super(key: key);

  @override
  State<DisplayAlarm> createState() => DisplayAlarmState();
}

class DisplayAlarmState extends State<DisplayAlarm> {
  static DateTime? alarmTime;
  static AlarmHelper alarmHelper = AlarmHelper();
  static Future<List<AlarmInfo>>? alarms;
  static List<AlarmInfo>? currentAlarms;

  @override
  void initState() {
    alarmTime = DateTime.now();
    alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    super.initState();
  }
void loadAlarms() {
    alarms = alarmHelper.getAlarms();
    if (mounted) setState(() =>{});
    print('loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Alarmdisplay',
            style:
                TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 24),
          ),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  currentAlarms = snapshot.data;
                  return ListView(
                    children: snapshot.data!.map<Widget>((alarm) {
                      var alarmTime =
                          DateFormat('jm').format(alarm.alarmDateTime!);
                      return Container(
                        
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 168, 168, 168),
                                Color.fromARGB(255, 68, 67, 67)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 4,
                                offset: const Offset(4, 4),
                              ),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24))),
                        child: Column(
                        
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                           
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  /*
                                  icon
                                  */
                                  children: <Widget>[
                                    /*Icon(
                                      Icons.label,
                                      color: Colors.white,
                                      size: 24,
                                    ),*/
                                   
                                    Text(
                                      alarm.title!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                        
                                    ),
                                  ],
                                ),
                                 IconButton(
                                 icon: Icon(Icons.settings_suggest_rounded), 
                                color: Colors.white,
                                 onPressed: () {  },
                                ),
                              ],
                            ),
                            const Text(
                              'Mon-Fri',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  alarmTime.toString(),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 20, 63, 30),
                                      fontSize: 18),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                    onPressed: () {
                                      deleteAlarm(alarm.id!);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).followedBy([
                      if (currentAlarms!.length < 5) const AddAlarmButton(),
                    ]).toList(),
                  );
                }
                return const Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }



  void deleteAlarm(int id) {
    alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }
}
