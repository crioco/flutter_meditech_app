import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_meditech_app/model/alarm_info.dart';
import 'package:flutter_meditech_app/widgets/add_Alarm.dart';




class DisplayAlarm extends StatefulWidget {
  const DisplayAlarm({Key? key}) : super(key: key);

  @override
  State<DisplayAlarm> createState() => _DisplayAlarmState();
}

class _DisplayAlarmState extends State<DisplayAlarm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Time',
            style:
                TextStyle(color: Color.fromARGB(255, 20, 63, 30), fontSize: 24),
          ),
          Expanded(
            child: ListView(
              children: alarms.map<Widget>((alarm) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
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
                          offset: Offset(4, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.label,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Office',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Switch(
                            value: true,
                            onChanged: (bool value) {},
                            activeColor: Colors.white,
                          ),
                        ],
                      ),
                      Text(
                        'Mon-Fri',
                        style: TextStyle(
                            color: Color.fromARGB(255, 20, 63, 30),
                            fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '7:00 am',
                            style: TextStyle(
                                color: Color.fromARGB(255, 20, 63, 30),
                                fontSize: 25),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 36,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).followedBy([
               AddAlarmButton(),
              ]).toList(),
            ),
          ),
        ],
      ),
    );
  }



}
