import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';


class PickDay extends StatefulWidget {
  final String title;
  const PickDay(this.title,{ Key? key }) : super(key: key);
  

  @override
  State<PickDay> createState() => _PickDayState();
}

class _PickDayState extends State<PickDay> {
  List<bool> values = List.filled(7, false);
  @override
  Widget build(BuildContext context) {
    
     return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
            'The days that are currently selected are: ${valuesToEnglishDays(values, true)}'),
        WeekdaySelector(
          onChanged: (v) {
            printIntAsDay(v);
            print('hahaha $v');
            setState(() {
              values[v % 7] = !values[v % 7];
            });
          },
          values: values,
           selectedFillColor: Colors.blue,
          
        ),
      ],
    );
  }
  }
  printIntAsDay(int day) {
  print('Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
}

String intDayToEnglish(int day) {
  if (day % 7 == DateTime.monday % 7) return 'Mon';
  if (day % 7 == DateTime.tuesday % 7) return 'Tue';
  if (day % 7 == DateTime.wednesday % 7) return 'Wed';
  if (day % 7 == DateTime.thursday % 7) return 'Thu';
  if (day % 7 == DateTime.friday % 7) return 'Fri';
  if (day % 7 == DateTime.saturday % 7) return 'Sat';
  if (day % 7 == DateTime.sunday % 7) return 'Sun';
  throw '🐞 This should never have happened: $day';
}
String valuesToEnglishDays(List<bool?> values, bool? searchedValue) {
  final days = <String>[];
  for (int i = 0; i < values.length; i++) {
    final v = values[i];
    print(i);
    // Use v == true, as the value could be null, as well (disabled days).
    if (v == searchedValue) days.add(intDayToEnglish(i));
  }
  if (days.isEmpty) return 'NONE';
  return days.join(', ');
  
}

