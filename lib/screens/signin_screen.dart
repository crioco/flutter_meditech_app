import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_meditech_app/const/custom_styles.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/widgets/my_password_field.dart';
import 'package:flutter_meditech_app/widgets/my_text_button.dart';
import 'package:flutter_meditech_app/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';
import 'package:provider/provider.dart';
import '../auth_helper.dart';
import '../functions/global_functions.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isPasswordVisible = true;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 60, bottom: 30),
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome back.",
                            style: kHeadline,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "You've been missed!",
                            style: kBodyText2,
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          MyTextField(
                            textEditingController: _email,
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                          ),
                          MyPasswordField(
                            hintText: 'Password',
                            textEditingController: _password,
                            isPasswordVisible: isPasswordVisible,
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Dont't have an account? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpScreenRoute);
                          },
                          child: Text(
                            'Register',
                            style: kBodyText.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'Sign In',
                      onTap: _signIn,
                      bgColor: Colors.white,
                      textColor: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signIn() async {
    var email = _email.text.trim();
    var pw = _password.text.trim();

    if (email.isEmpty || pw.isEmpty) {
      await showOkAlertDialog(
        context: context,
        message: 'Check your email or password',
      );
      return;
    }

    var user = await AuthHelper.signIn(email, pw);

    if (user is User) {
      if (await getUserDevice(user)){
        await getData();
      }
      Navigator.pushNamedAndRemoveUntil(
          context, ReminderScreenRoute, (Route<dynamic> route) => false);
    } else {
      await showOkAlertDialog(
        context: context,
        message: user,
      );
    }
  }

  Future<bool> getUserDevice(User user) async{
    var userID = user.uid;

    DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
    .collection('Users').doc(userID).get();
    var data = query.data();

    var firstName = data!['firstname'];
    var lastName = data['lastname'];
    Provider.of<DataProvider>(context, listen: false).changeUser(userID: userID, firstName: firstName, lastName: lastName);
    
    var deviceID = data['device'];
    if(deviceID == 'NULL'){return false;} 
    Provider.of<DataProvider>(context, listen: false).changeDeviceID(deviceID);

    await DataSharedPreferences.setDeviceID(deviceID);
    await DataSharedPreferences.setUserID(userID);
    await DataSharedPreferences.setFirstName(firstName);
    await DataSharedPreferences.setLastName(lastName);

    return true;
  }

  getData() async{
    DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
    .collection('DEVICES').doc(Provider.of<DataProvider>(context, listen: false).deviceID).get();

    var data = query.data();
    var ringDuration = data!['ringDuration'] as int;
    var snoozeDuration = data['snoozeDuration'] as int;
    var snoozeAmount = data['snoozeAmount'] as int;
    var pillSettings = data['pillSettings'].cast<Map<String, dynamic>>();

    List<Pill> pillList = [];

    for (var pill in pillSettings){
      var pillName = pill['pillName'] as String;
      var days = pill['days'].cast<int>();
      var containerSlot = pill['containerSlot'] as int;
      var alarmListObj = pill['alarmList'].cast<Map<String, dynamic>>();

      List<Map<String,dynamic>> alarmList = [];
      for (var alarm in alarmListObj){
        alarmList.add({'dosage': alarm['dosage'] as int, 'time': alarm['time'] as int});
      }

      pillList.add(Pill(pillName: pillName, days: days, containerSlot: containerSlot, alarmList: alarmList));
    }

    Provider.of<DataProvider>(context, listen: false).changeAlarmSettings(snoozeDuration: snoozeDuration, snoozeAmount: snoozeAmount, ringDuration: ringDuration);
    Provider.of<DataProvider>(context, listen: false).changePillList(pillList);

    // print(Provider.of<DataProvider>(context, listen: false).deviceID);
    // print(Provider.of<DataProvider>(context, listen: false).userID);
    // print(Provider.of<DataProvider>(context, listen: false).firstName);
    // print(Provider.of<DataProvider>(context, listen: false).lastName);
    // print(Provider.of<DataProvider>(context, listen: false).ringDuration);
    // print(Provider.of<DataProvider>(context, listen: false).snoozeDuration);
    // print(Provider.of<DataProvider>(context, listen: false).snoozeAmount);

    // var temp = Provider.of<DataProvider>(context, listen: false).pillList;

    // for (var item in temp){
    //   print(item.pillName);
    //   print(item.containerSlot.toString());
    //   print(item.days.toString());
      
    //   for (var map in item.alarmList){
    //     print('dosage: ${map['dosage']} time: ${map['time']}');
    //   }
    // }

    var arrangedAlarms = getArrangedAlarm(pillList);
    Provider.of<DataProvider>(context, listen: false).changeArrangedAlarms(arrangedAlarms);

    String jsonPillList = jsonEncode(pillList);

    await DataSharedPreferences.setPillList(jsonPillList);
    await DataSharedPreferences.setRingDuration(ringDuration);
    await DataSharedPreferences.setSnoozeDuration(snoozeDuration);
    await DataSharedPreferences.setSnoozeAmount(snoozeDuration);

  }

}
