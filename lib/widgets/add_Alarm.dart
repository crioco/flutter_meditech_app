import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_meditech_app/screens/clock_view.dart';
import 'package:intl/intl.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import '../model/alarm_info.dart';
import '../model/schedule_Alarm.dart';
import '../screens/display_alarm.dart';
import 'day_Picker.dart';
import 'my_text_field.dart';
// final values = List.filled(7, true);

class AddAlarmButton extends StatefulWidget {
  const AddAlarmButton({Key? key}) : super(key: key);

  @override
  State<AddAlarmButton> createState() => AddAlarmButtonState();
}

class AddAlarmButtonState extends State<AddAlarmButton> {
  final TextEditingController alarmlabel = TextEditingController();
  final TextEditingController medicinename = TextEditingController();
  static String? alarmTimeString;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.10,
      height: MediaQuery.of(context).size.height * 0.10,
      decoration: const BoxDecoration(
          color: Color.fromARGB(251, 0, 162, 255),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: TextButton(
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/addw.png',
              scale: 3,
            ),
            const SizedBox(
              width: 3,
            ),
            const Text(
              'Add Alarm',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),

        onPressed: () {
          alarmTimeString = DateFormat('jm').format(DateTime.now());
          showModalBottomSheet(
            isScrollControlled: true,
            useRootNavigator: true,
            context: context,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setModalState) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          ElevatedButton(
                           
                            onPressed: () async {
                              var selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selectedTime != null) {
                                final now = DateTime.now();
                                var selectedDateTime = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    selectedTime.hour,
                                    selectedTime.minute);
                                DisplayAlarmState.alarmTime = selectedDateTime;
                                setModalState(() {
                                  alarmTimeString =
                                      DateFormat('jm').format(selectedDateTime);
                                });
                              }
                            },
                            child: Text(
                              alarmTimeString!,
                              style: const TextStyle(fontSize: 32),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(183, 207, 206, 202), // background
                              onPrimary: Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                          ),
                          PickDay(' '),
                          Padding(
                             padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: MyTextField(
                                hintText: 'Medicine',
                                inputType: TextInputType.text,
                                textEditingController: medicinename),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(
                              left: 4,
                              right: 4,
                                 bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: MyTextField(
                                hintText: 'Label/Dosage',
                                inputType: TextInputType.text,
                                textEditingController: alarmlabel),
                          ),
                          FloatingActionButton.extended(
                            onPressed: onSaveAlarm,
                            icon: const Icon(Icons.alarm),
                            label: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
          // scheduleAlarm();
        },
        // scheduleAlarm();
      ),
    );
  }

  Future<void> onSaveAlarm() async {
    DateTime? scheduleAlarmDateTime;

    if (DisplayAlarmState.alarmTime!.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = DisplayAlarmState.alarmTime!;
    } else {
      scheduleAlarmDateTime =
          DisplayAlarmState.alarmTime!.add(const Duration(days: 1));
    }

    if (alarmlabel.text.isEmpty) {
      alarmlabel.text = 'Time to take your medicine';
    }
    if (medicinename.text.isEmpty) {
      medicinename.text = 'Pills';
    }
    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: DisplayAlarmState.currentAlarms!.length,
      title: medicinename.text,
      alarmLabel: alarmlabel.text,
    );

    DisplayAlarmState.alarmHelper.insertAlarm(alarmInfo);
    scheduleAlarm(scheduleAlarmDateTime, alarmInfo);
    DisplayAlarmState().loadAlarms();
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ClockView()),
      (Route<dynamic> route) => false,
    );
  }
}
