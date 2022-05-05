import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:intl/intl.dart';
import 'display_alarm.dart';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() =>_ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('jm').format(now);
    var formattedDate = DateFormat('yMMMMd').format(now);
    return Scaffold(
      appBar: const MyAppBar(title: 'Clock'),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Time',
              style:
                  TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 24),
            ),
            Text(
              formattedTime,
              style:
                  TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 64),
            ),
            Text(
              formattedDate,
              style:
                  TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
            ),
            Expanded(child: DisplayAlarm()),
          ],
        ),

        /**  child: Container(
            alignment: Alignment.center,
            child: ClockView()
            ),*/
      ),
    );
  }
}
