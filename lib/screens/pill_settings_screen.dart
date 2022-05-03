import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/providers/selected_pill_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    List<Pill> pillList = Provider.of<DataProvider>(context).pillList;
    return Scaffold(
        key: _key,
        appBar: MyAppBar(title: 'Pill Settings'),
        drawer: const MySideMenu(),
        endDrawer: endDrawer,
        endDrawerEnableOpenDragGesture: false,
        body: (deviceID != 'NULL') 
        ? Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/pill_box_grid_default.jpg',
                  width: 400,
                  height: 200,
                ),
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
}
