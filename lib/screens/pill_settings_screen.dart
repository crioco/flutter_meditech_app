import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/functions/global_functions.dart';
import 'package:flutter_meditech_app/main.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/providers/selected_pill_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/screens/DiscoveryPage.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';
import 'package:flutter_meditech_app/const/container_maps.dart';
import 'package:flutter_meditech_app/widgets/pill_setting_drawer.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:provider/provider.dart';

class PillSettingsScreen extends StatefulWidget {
  const PillSettingsScreen({Key? key}) : super(key: key);

  @override
  State<PillSettingsScreen> createState() => _PillSettingsScreenState();
}

class _PillSettingsScreenState extends State<PillSettingsScreen> {
  var endDrawer = const PillSettingDrawer();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String deviceID = DataSharedPreferences.getDeviceID();
  List<Pill> pillList = [];

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothDevice selectedDevice = const BluetoothDevice(address: '');

  String _address = "...";
  String _name = "...";

  /////////////////////////////// FROM CHAT PAGE
  
  static final clientID = 0;
  var connection; //BluetoothConnection
  bool isConnecting = true;
  bool isDisconnecting = false;
  String _messageBuffer = '';

  ////////////////////////////////
  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled??false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    pillList = Provider.of<DataProvider>(context).pillList;

    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: const Text('Pill Settings'),
          actions: [
            IconButton( icon: const Iconify(Ion.settings_sharp, color: Colors.white), onPressed: (){
              Navigator.pushNamed(context, DeviceSettingsScreenRoute);
            }),
            IconButton( icon: const Iconify(Ion.bluetooth_sharp, color: Colors.white), onPressed: (){
              enableBLU(context);
            }),
            (isConnected()) 
            ? IconButton( icon: const Iconify(Ion.md_cloud_upload, color: Colors.white), onPressed: (){
              uploadToBLU();
            })
            : Container(),
          ],
        ),
        drawer: const MySideMenu(),
        endDrawer: endDrawer,
        endDrawerEnableOpenDragGesture: false,
        body: (deviceID != 'NULL') 
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/pill_box_default.png',
                  width: 400,
                  height: 200,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        Pill pill = const Pill(pillName: '', containerSlot: 0, days: [], alarmList: []);
                        if(index <= pillList.length-1) {pill = pillList[index];}
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: (index <= pillList.length-1) 
                          ? ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text(
                              pill.pillName,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                            tileColor: containerColorMap[pill.containerSlot],
                            trailing: const Iconify(Ion.ellipsis_horizontal_sharp, color: Colors.white),
                            onTap: () {
                              setState(() {
                                Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedPill(pill);
                                Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedPillIndex(index); 
                                endDrawer = const PillSettingDrawer();
                              });
                              _key.currentState!.openEndDrawer();
                            },
                          )
                          : ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            title: const Text('Empty', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                            tileColor: Colors.grey,
                            trailing: const Iconify(Ion.plus, color: Colors.black),
                            onTap: () {
                              List<int> availableSlots = [];
                              List<int> takenSlots = [];
                              for (var pill in Provider.of<DataProvider>(context, listen: false).pillList) {
                                takenSlots.add(pill.containerSlot);
                              }

                              for (var index = 1; index <= 5; index++){
                                if(!takenSlots.contains(index)){
                                  availableSlots.add(index);
                                }
                              }
                              Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedPillName('');
                              Provider.of<SelectedPillProvider>(context, listen: false).changeInitialAvailSlot(availableSlots[0]);
                              Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedDays([1]); 
                              Provider.of<SelectedPillProvider>(context, listen: false).changeSelectedAlarmList([]); 
                              Provider.of<SelectedPillProvider>(context, listen: false).changeAvailableSlots(availableSlots);
                              
                              Navigator.pushNamed(context, AddPillSettingScreenRoute);
                            },
                          )
                          ,
                        );
                      }),
                )
              ],
            ))
            : const Center(
                child: SizedBox(
              height: 70,
              width: 200,
              child: Text('No Device Registered'),
            )),);
  }

bool isConnected() {
  return connection != null && connection.isConnected;
}


void enableBLU(BuildContext context) async {
  if (await FlutterBluetoothSerial.instance.isEnabled as bool == false){
      await FlutterBluetoothSerial.instance.requestEnable();
    }

    if (await FlutterBluetoothSerial.instance.isEnabled as bool){
    selectedDevice =
        await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const DiscoveryPage();
        },
      ),
    );

    if (selectedDevice != null) {
      print('Discovery -> selected ' + selectedDevice.address);

      BluetoothConnection.toAddress(selectedDevice.address).then((_connection) async {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      _sendMessage('69');

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
    } else {
      print('Discovery -> no device selected');
    }}
}

void uploadToBLU() async {
  if(isConnected()){
        var ringDuration = Provider.of<DataProvider>(context, listen: false).ringDuration;
        var snoozeDuration = Provider.of<DataProvider>(context, listen: false).snoozeDuration;
        var snoozeAmount = Provider.of<DataProvider>(context, listen: false).snoozeAmount;
        var wifiSSID = Provider.of<DataProvider>(context, listen: false).wifiSSID;
        var wifiPassword = Provider.of<DataProvider>(context, listen: false).wifiPassword;

        var wifiJson = '2{"WIFI_SSID":"$wifiSSID","WIFI_PASSWORD":"$wifiPassword"}';
        var deviceJson = '3{"ringDuration":${ringDuration*60000},"snoozeDuration":${snoozeDuration*60000},"snoozeAmount":$snoozeAmount}';
        var jsonPillList = jsonEncode(pillList);
        
        await Future.delayed(const Duration(seconds: 1));
        String jsonPillListS = '1'+jsonPillList;
        _sendMessage(jsonPillListS);
        
        await Future.delayed(const Duration(seconds: 1));
        _sendMessage(deviceJson);
        
        await Future.delayed(const Duration(seconds: 1));
        _sendMessage(wifiJson);

        await DataSharedPreferences.setPillList(jsonPillList);
        await DataSharedPreferences.setRingDuration(ringDuration);
        await DataSharedPreferences.setSnoozeDuration(snoozeDuration);
        await DataSharedPreferences.setSnoozeAmount(snoozeAmount);
        await DataSharedPreferences.setWiFiSSID(wifiSSID);
        await DataSharedPreferences.setWiFiPassword(wifiPassword);


        // SETTING MOBILE APP ALARM
        var alarmTimeList = [];

        for (var pill in pillList){
          var alarmList = pill.alarmList;
          for(var map in alarmList){
            var alarmTime = map['time'];
            if(!alarmTimeList.contains(alarmTime)){
              alarmTimeList.add(alarmTime);
            }
          } 
        }
       
        await flutterLocalNotificationsPlugin.cancelAll();
        for (var index = 0; index < alarmTimeList.length; index++){
          var time = alarmTimeList[index];
          var hour = (time/100).floor();
          var minute = time%100;
          var now = DateTime.now();
          await scheduleAlarm(DateTime(now.year, now.month, now.day, hour, minute), index);
        }

        var arrangedAlarms = getArrangedAlarm(pillList);
        Provider.of<DataProvider>(context, listen: false).changeArrangedAlarms(arrangedAlarms);

        List<Map<String, dynamic>> pillSettings = pillList.map((pill)=> pill.toMap()).toList();

        var deviceID = Provider.of<DataProvider>(context, listen: false).deviceID;
        var docRef =  FirebaseFirestore.instance.collection('DEVICES').doc(deviceID);
        await docRef.update({'pillSettings': pillSettings, 'ringDuration':ringDuration, 
        'snoozeDuration': snoozeDuration, 'snoozeAmount': snoozeAmount, 'wifiSSID': wifiSSID, 
        'wifiPassword': wifiPassword})
        .then((value) async{
          // Provider.of<SelectedPillProvider>(context, listen:false).changeSelectedInitialSlot(containerSlot);
          // Provider.of<DataProvider>(context, listen:false).changePillList(pillList);
          // String jsonPillList = jsonEncode(pillList);
          // await DataSharedPreferences.setPillList(jsonPillList);

          // var arrangedAlarms = getArrangedAlarm(pillList);
          // Provider.of<DataProvider>(context, listen: false).changeArrangedAlarms(arrangedAlarms);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Settings Has Been Updated'),
          backgroundColor: Color.fromARGB(255, 74, 204, 79),
          ));
        })
        .catchError((error){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to Update Settings'),
          backgroundColor: Color.fromARGB(255, 196, 69, 69),
          ));
        });

        // await docRef.update({'ringDuration':ringDuration, 'snoozeDuration': snoozeDuration, 'snoozeAmount': snoozeAmount})
        //   .then((value) async{
            
        //     await DataSharedPreferences.setRingDuration(ringDuration);
        //     await DataSharedPreferences.setSnoozeDuration(snoozeDuration);
        //     await DataSharedPreferences.setSnoozeAmount(snoozeAmount);

        //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('Device Settings Has Been Updated'),
        //     backgroundColor: Color.fromARGB(255, 74, 204, 79),
        //     ));
        //   })
        //   .catchError((error){
        //     print(error);
        //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('Failed to Update Device Settings'),
        //     backgroundColor: Color.fromARGB(255, 196, 69, 69),
        //     ));
        //   });
        }
}

// void _startChat(BuildContext context, BluetoothDevice server) {
   
//    BluetoothConnection.toAddress(server.address).then((_connection) async {
//       print('Connected to the device');
//       connection = _connection;
//       setState(() {
//         isConnecting = false;
//         isDisconnecting = false;
//       });

//       connection.input.listen(_onDataReceived).onDone(() {
//         // Example: Detect which side closed the connection
//         // There should be `isDisconnecting` flag to show are we are (locally)
//         // in middle of disconnecting process, should be set before calling
//         // `dispose`, `finish` or `close`, which all causes to disconnect.
//         // If we except the disconnection, `onDone` should be fired as result.
//         // If we didn't except this (no flag set), it means closing by remote.
//         if (isDisconnecting) {
//           print('Disconnecting locally!');
//         } else {
//           print('Disconnected remotely!');
//         }
//         if (this.mounted) {
//           setState(() {});
//         }
//       });
//     }).catchError((error) {
//       print('Cannot connect, exception occured');
//       print(error);
//     });

//   }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }

    // print(_messageBuffer);
  }

  void _sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  Future<void> scheduleAlarm(DateTime scheduledNotificationDateTime, int id) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    channelDescription: 'your channel description',
    icon: 'alarm_icon',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    additionalFlags: Int32List.fromList(<int>[4]),
    sound: const RawResourceAndroidNotificationSound('alarm_sound'),
    largeIcon: const DrawableResourceAndroidBitmap('alarm_icon'),
  );

  var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      sound: 'alarm_sound.mp3',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(id ,'Alarm', 'Please Take Your Scheduled Pills. uwu', 
      scheduledNotificationDateTime, platformChannelSpecifics);

}

}