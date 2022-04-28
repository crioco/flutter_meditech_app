import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';

class PillSettingsScreen extends StatefulWidget {
  const PillSettingsScreen({ Key? key }) : super(key: key);

  @override
  State<PillSettingsScreen> createState() => _PillSettingsScreenState();
}

class _PillSettingsScreenState extends State<PillSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Pill Settings'),
      drawer: const MySideMenu(),
      body: Container(),
    );
  }
}