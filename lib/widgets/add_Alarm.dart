import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/screens/clock_view.dart';
import 'package:intl/intl.dart';

import '../model/alarm_info.dart';
import '../model/schedule_Alarm.dart';
import '../screens/display_alarm.dart';


class AddAlarmButton extends StatefulWidget {
  const AddAlarmButton({ Key? key }) : super(key: key);

  @override
  State<AddAlarmButton> createState() => AddAlarmButtonState();
  
}


class AddAlarmButtonState extends State<AddAlarmButton> {

 static String? alarmTimeString;


  

 

 
  @override
  Widget build(BuildContext context) {
    return Container(
     child:  DottedBorder(
                  strokeWidth: 3,
                  color: Colors.black12,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(24),
                  dashPattern: [5,4],
                  child: Container(
                  
                   width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(24))
                    ) ,
                   
                    child: FlatButton(
                       padding: const EdgeInsets.symmetric(horizontal: 32, vertical:16),
                    onPressed: () {
                                alarmTimeString =
                                    DateFormat('jm').format(DateTime.now());
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Container(
                                          padding: const EdgeInsets.all(32),
                                          
                                          child: Column(
                                            children: [
                                              FlatButton(
                                                color: Color.fromARGB(255, 0, 255, 255),
                                                onPressed: () async {
                                                  var selectedTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                                  if (selectedTime != null) {
                                                    final now = DateTime.now();
                                                    var selectedDateTime =
                                                        DateTime(
                                                            now.year,
                                                            now.month,
                                                            now.day,
                                                            selectedTime.hour,
                                                            selectedTime
                                                                .minute);
                                                   DisplayAlarmState.alarmTime =
                                                        selectedDateTime;
                                                    setModalState(() {
                                                      alarmTimeString =
                                                          DateFormat('jm')
                                                              .format(
                                                                  selectedDateTime);
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  alarmTimeString!,
                                                  style:
                                                      TextStyle(fontSize: 32),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text('Repeat'),
                                                trailing: Icon(
                                                    Icons.arrow_forward_ios),
                                              ),
                                              ListTile(
                                                title: Text('Sound'),
                                                trailing: Icon(
                                                    Icons.arrow_forward_ios),
                                              ),
                                              ListTile(
                                                title: Text('Title'),
                                                trailing: Icon(
                                                    Icons.arrow_forward_ios),
                                              ),
                                              FloatingActionButton.extended( 
                                                onPressed: onSaveAlarm,
                                                icon: Icon(Icons.alarm),
                                                label: Text('Save'),
                                                
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                                // scheduleAlarm();
                              },
                       // scheduleAlarm();
                      
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/add.png',
                            
                            scale: 1.5,
                          ),
                          SizedBox(height: 8,),
                          Text(
                            'Add Alarm',
                            style: TextStyle(
                              color: Colors.white,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      
    );
  }
  void onSaveAlarm() {
    
    DateTime? scheduleAlarmDateTime;
    if (DisplayAlarmState.alarmTime!.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = DisplayAlarmState.alarmTime!;
      print('1');
    } else 
      scheduleAlarmDateTime = DisplayAlarmState.alarmTime!.add(Duration(days: 1));
     print('2');
    

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: DisplayAlarmState.currentAlarms!.length,
      title: 'alarm',
    );
    
    DisplayAlarmState.alarmHelper.insertAlarm(alarmInfo);
    scheduleAlarm(scheduleAlarmDateTime, alarmInfo);
      DisplayAlarmState().loadAlarms();
    Navigator.pop(context);
  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => ClockView()),
  (Route<dynamic> route) => false,
);
       
     print('4');
     

  }
    
  
  
  
}

