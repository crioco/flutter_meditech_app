import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/const/container_maps.dart';
import 'package:flutter_meditech_app/functions/global_functions.dart';

import '../model/pill_object.dart';

class PillSettingDrawer extends StatelessWidget {
  const PillSettingDrawer({
    Key? key,
    this.pill =
        const Pill(pillName: '', containerSlot: 0, days: [], alarmList: []),
  }) : super(key: key);

  final Pill pill;

  static const Map<int, String> dayOfWeek = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  @override
  Widget build(BuildContext context) {
    var pillName = pill.pillName;
    var containerSlot = pill.containerSlot;
    var days = [1, 2, 3, 4, 5, 6, 7];
    var alarmList = pill.alarmList;
    bool isDaysSeries = true;

    for (var index = 0; index < days.length-1; index++){
      if ((days[index] + 1) != days[index+1]) isDaysSeries = false;
    }
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
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
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
