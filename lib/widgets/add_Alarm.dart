import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'schedule_Alarm.dart';

class AddAlarmButton extends StatefulWidget {
  const AddAlarmButton({ Key? key }) : super(key: key);

  @override
  State<AddAlarmButton> createState() => _AddAlarmButtonState();
}

class _AddAlarmButtonState extends State<AddAlarmButton> {
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
                      onPressed: (){
                        scheduleAlarm();
                      },
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