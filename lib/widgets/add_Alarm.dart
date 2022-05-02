import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/display_alarm.dart';
import 'schedule_Alarm.dart';

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
                                                onPressed: DisplayAlarmState().onSaveAlarm,
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
  
  
  
  
}

