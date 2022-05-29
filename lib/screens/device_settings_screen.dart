import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:provider/provider.dart';

class DeviceSettingsScreen extends StatefulWidget {
  const DeviceSettingsScreen({ Key? key }) : super(key: key);

  @override
  State<DeviceSettingsScreen> createState() => _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends State<DeviceSettingsScreen> {
  
  
  @override
  Widget build(BuildContext context) {
    int ringDuration = Provider.of<DataProvider>(context).ringDuration;
    int snoozeDuration = Provider.of<DataProvider>(context).snoozeDuration;
    int snoozeAmount = Provider.of<DataProvider>(context).snoozeAmount;

    String wifiSSID = Provider.of<DataProvider>(context).wifiSSID;
    String wifiPassword = Provider.of<DataProvider>(context).wifiPassword;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Settings'),
        leading: IconButton( 
          icon:const Iconify(Ion.md_arrow_back, color: Colors.white, size: 30,),
          onPressed: (){
            Provider.of<DataProvider>(context, listen: false).changeRingDuration(DataSharedPreferences.getRingDuration());
            Provider.of<DataProvider>(context, listen: false).changeSnoozeDuration(DataSharedPreferences.getSnoozeDuration());
            Provider.of<DataProvider>(context, listen: false).changeSnoozeAmount(DataSharedPreferences.getSnoozeAmount());
            Provider.of<DataProvider>(context, listen: false).changeWiFiPassword(DataSharedPreferences.getWiFiPassword());
            Provider.of<DataProvider>(context, listen: false).changeWiFiSSID(DataSharedPreferences.getWiFiSSID());
            Navigator.of(context).pop();
        }),
        actions: [
        IconButton( icon: const Iconify(Ion.md_checkmark, color: Colors.white), onPressed: () async{
          Navigator.of(context).pop();
        }),
      ]
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Alarm Configuration', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(thickness: 1, height: 1,),
                  ListTile(
                    title: Row(children: [
                      const Text('Ring Duration: '),
                      const Spacer(),
                      (ringDuration > 1)
                      ? Text('$ringDuration  minutes')
                      : Text('$ringDuration  minute')
                    ]),
                    trailing: const Iconify(Ion.chevron_right),
                    onTap: (){
                      showRingDurationDialog(context, ringDuration);
                    },
                  ),
                  ListTile(
                    title: Row(children: [
                      const Text('Snooze Duration: '),
                      const Spacer(),
                      (snoozeDuration > 1)
                      ? Text('$snoozeDuration  minutes')
                      : Text('$snoozeDuration  minute')
                    ]),
                    trailing: const Iconify(Ion.chevron_right),
                    onTap: (){
                      showSnoozeDurationDialog(context, snoozeDuration);
                    },
                  ),
                  ListTile(
                    title: Row(children: [
                      const Text('Snooze Amount: '),
                      const Spacer(),
                      (snoozeAmount > 1)
                      ? Text('$snoozeAmount  times')
                      : Text('$snoozeAmount  time')
                    ]),
                    trailing: const Iconify(Ion.chevron_right),
                    onTap: (){
                      showSnoozeAmountDialog(context, snoozeAmount);
                    },
                 ),
                 const SizedBox(height: 30),
                //  OutlinedButton( 
                //   child: const Text('UPDATE SETTINGS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                //   style: OutlinedButton.styleFrom(
                //           fixedSize: const Size(215, 50),
                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                //           side: const BorderSide(color: Colors.blueAccent, width: 2),
                //           primary: Colors.blueAccent,),
                //   onPressed: (){  
                //     updateDeviceSettings(context);
                //  },)
                ]),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('WiFi Configuration', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                const Divider(thickness: 1, height: 1,),
                Column(children: [
                  ListTile(
                    title: Row(children: [
                      const Text('WiFi SSID:'),
                      const Spacer(),
                      Text(wifiSSID)
                    ]),
                    onTap: (){
                      showSSIDDialog(context);
                    },
                    trailing: const Iconify(Ion.chevron_right),
                  ),
                   ListTile(
                    title: Row(children: [
                    const Text('WiFi Password:'),
                    const Spacer(),
                    Text(wifiPassword)
                    ],),
                    onTap: (){
                      showPasswordDialog(context);
                    },
                    trailing: const Iconify(Ion.chevron_right),
                  ),
                ],),
                // OutlinedButton( 
                // child: const Text('UPDATE WiFI SETTINGS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                // style: OutlinedButton.styleFrom(
                //         fixedSize: const Size(215, 50),
                //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                //         side: const BorderSide(color: Colors.blueAccent, width: 2),
                //         primary: Colors.blueAccent,),
                // onPressed: (){  
                  
                // },)
            ],))
          ],
        ),
      ),
    );
  }

  void showRingDurationDialog(BuildContext context, int ringDuration){
    final labels = ['1', '5', '10','15','20', '25', '30'];
    double min = 0;
    double max = labels.length - 1;
    int labelIndex = 0;

    for (var index = 0; index < labels.length; index++){
      if(labels[index] == ringDuration.toString()){
        labelIndex = index;
      }
    }
    showDialog(context: context,  builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
        return AlertDialog(
          insetPadding: const EdgeInsets.all(15),
          titlePadding: const EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Ring Duration', style: TextStyle(fontSize: 25)),
              ),
              Divider(thickness: 1, height: 1)
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.grey
                )
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Provider.of<DataProvider>(context, listen: false).changeRingDuration(int.parse(labels[labelIndex]));
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('CONFIRM'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.blueAccent
                )
                ),
              ],
            ),
          ],
          content: SizedBox(          
            width: double.maxFinite,
            height: 100,
            child: Column(
              children: [
                Slider.adaptive(
                  value: labelIndex.toDouble(),
                  min: min,
                  max: max,
                  divisions: labels.length-1,
                  label: labels[labelIndex],
                  onChanged: (value){
                    setState(() {
                      labelIndex = value.toInt();
                    });
                  }),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Utils.modelBuilder(labels, (index, label){
                      final isSelected = index <= labelIndex;
                      final color = isSelected ? Colors.black : Colors.black.withOpacity(0.3);

                      return buildLabel(label: label as String, width: 30, color: color);
                                        
                    })
                  )
                )
              ],
            ),
          ),
        );
        });
    });
  }

  void showSnoozeDurationDialog(BuildContext context, int snoozeDuration){
    final labels = ['1', '5', '10','15','20', '25', '30'];
    double min = 0;
    double max = labels.length - 1;
    int labelIndex = 0;

    for (var index = 0; index < labels.length; index++){
      if(labels[index] == snoozeDuration.toString()){
        labelIndex = index;
      }
    }
    showDialog(context: context,  builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
        return AlertDialog(
          insetPadding: const EdgeInsets.all(15),
          titlePadding: const EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Snooze Duration', style: TextStyle(fontSize: 25)),
              ),
              Divider(thickness: 1, height: 1)
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.grey
                )
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Provider.of<DataProvider>(context, listen: false).changeSnoozeDuration(int.parse(labels[labelIndex]));
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('CONFIRM'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.blueAccent
                )
                ),
              ],
            ),
          ],
          content: SizedBox(          
            width: double.maxFinite,
            height: 100,
            child: Column(
              children: [
                Slider.adaptive(
                  value: labelIndex.toDouble(),
                  min: min,
                  max: max,
                  divisions: labels.length-1,
                  label: labels[labelIndex],
                  onChanged: (value){
                    setState(() {
                      labelIndex = value.toInt();
                    });
                  }),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Utils.modelBuilder(labels, (index, label){
                      final isSelected = index <= labelIndex;
                      final color = isSelected ? Colors.black : Colors.black.withOpacity(0.3);

                      return buildLabel(label: label as String, width: 30, color: color);
                                        
                    })
                  )
                )
              ],
            ),
          ),
        );
        });
    });
  }

  void showSnoozeAmountDialog(BuildContext context, int snoozeAmount){
    final labels = ['1', '3', '5','10'];
    double min = 0;
    double max = labels.length - 1;
    int labelIndex = 0;

    for (var index = 0; index < labels.length; index++){
      if(labels[index] == snoozeAmount.toString()){
        labelIndex = index;
      }
    }
    showDialog(context: context,  builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
        return AlertDialog(
          insetPadding: const EdgeInsets.all(15),
          titlePadding: const EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Snooze Amount', style: TextStyle(fontSize: 25)),
              ),
              Divider(thickness: 1, height: 1)
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.grey
                )
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Provider.of<DataProvider>(context, listen: false).changeSnoozeAmount(int.parse(labels[labelIndex]));
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('CONFIRM'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.blueAccent
                )
                ),
              ],
            ),
          ],
          content: SizedBox(          
            width: double.maxFinite,
            height: 100,
            child: Column(
              children: [
                Slider.adaptive(
                  value: labelIndex.toDouble(),
                  min: min,
                  max: max,
                  divisions: labels.length-1,
                  label: labels[labelIndex],
                  onChanged: (value){
                    setState(() {
                      labelIndex = value.toInt();
                    });
                  }),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Utils.modelBuilder(labels, (index, label){
                      final isSelected = index <= labelIndex;
                      final color = isSelected ? Colors.black : Colors.black.withOpacity(0.3);

                      return buildLabel(label: label as String, width: 30, color: color);
                                        
                    })
                  )
                )
              ],
            ),
          ),
        );
        });
    });
  }


  void showSSIDDialog(BuildContext context){
    var wifiSSID = Provider.of<DataProvider>(context, listen: false).wifiSSID;
    showDialog(context: context,  builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
        return AlertDialog(
          insetPadding: const EdgeInsets.all(15),
          titlePadding: const EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('WiFI SSID', style: TextStyle(fontSize: 25)),
              ),
              Divider(thickness: 1, height: 1)
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.grey
                )
                ),
                ElevatedButton(
                  onPressed: () {
                   
                    Navigator.of(context).pop();
                  },
                  child: const Text('CONFIRM'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.blueAccent
                )
                ),
              ],
            ),
          ],
          content: SizedBox(          
            width: double.maxFinite,
            height: 75,
            child: Column(
              children: [
                TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  initialValue: wifiSSID,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'WiFi SSID',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text){
                      Provider.of<DataProvider>(context, listen: false)
                    .changeWiFiSSID(text);
                  },                      
                )
              ],
            ),
          ),
        );
        });
    });
  }

  void showPasswordDialog(BuildContext context){
    var wifiPassword = Provider.of<DataProvider>(context, listen: false).wifiPassword;
    showDialog(context: context,  builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
        return AlertDialog(
          insetPadding: const EdgeInsets.all(15),
          titlePadding: const EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('WiFI SSID', style: TextStyle(fontSize: 25)),
              ),
              Divider(thickness: 1, height: 1)
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.grey
                )
                ),
                ElevatedButton(
                  onPressed: () {
                   
                    Navigator.of(context).pop();
                  },
                  child: const Text('CONFIRM'),
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.blueAccent
                )
                ),
              ],
            ),
          ],
          content: SizedBox(          
            width: double.maxFinite,
            height: 75,
            child: Column(
              children: [
                TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  initialValue: wifiPassword,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'WiFi Password',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text){
                      Provider.of<DataProvider>(context, listen: false)
                    .changeWiFiPassword(text);
                  },                      
                )
              ],
            ),
          ),
        );
        });
    });
  }


  Future updateDeviceSettings(BuildContext context) async {
    // var ringDuration = Provider.of<DataProvider>(context, listen: false).ringDuration;
    // var snoozeDuration = Provider.of<DataProvider>(context, listen: false).snoozeDuration;
    // var snoozeAmount = Provider.of<DataProvider>(context, listen: false).snoozeAmount;

    // var deviceID = Provider.of<DataProvider>(context, listen: false).deviceID;
    // var docRef =  FirebaseFirestore.instance.collection('DEVICES').doc(deviceID);
    // await docRef.update({'ringDuration':ringDuration, 'snoozeDuration': snoozeDuration, 'snoozeAmount': snoozeAmount})
    // .then((value) async{
     
    //   await DataSharedPreferences.setRingDuration(ringDuration);
    //   await DataSharedPreferences.setSnoozeDuration(snoozeDuration);
    //   await DataSharedPreferences.setSnoozeAmount(snoozeAmount);

    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //   content: Text('Device Settings Has Been Updated'),
    //   backgroundColor: Color.fromARGB(255, 74, 204, 79),
    //   ));
    // })
    // .catchError((error){
    //   print(error);
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //   content: Text('Failed to Update Device Settings'),
    //   backgroundColor: Color.fromARGB(255, 196, 69, 69),
    //   ));
    // });
  }

  buildLabel({
    required String label,
    required double width,
    required Color color,
  }) => SizedBox(
    width: width,
    child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold).copyWith(color: color)),
  ); 
}

class Utils {
  static List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}
