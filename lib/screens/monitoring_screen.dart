import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({Key? key}) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  List<String> monitorList = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Monitoring'),
      drawer: const MySideMenu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: monitorList.map((id){

          
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Center(child: Text(id)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tileColor: Colors.grey,
            onTap: () async {
              String deviceID = '';
              await FirebaseFirestore.instance.collection('Users').doc(id).get().then((value){
                deviceID = value.data()!['device'];
              });
              await DataSharedPreferences.setMonitorID(deviceID);
              Navigator.pushNamed(context, MonitorSummaryScreenRoute, arguments: deviceID);
            },
          ),
        );
      }).toList(),),
    );
  }

  getList() async{
    List<String> monitorList = [];
    var userID = Provider.of<DataProvider>(context, listen: false).userID;
    await FirebaseFirestore.instance.collection('Users').doc(userID).get().then((value){
      setState(() {
        for (var element in List.from(value.data()!['monitorList'])) {
          monitorList.add(element);
        }
        this.monitorList = monitorList;
      });
    });
  }
}
