import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/auth_helper.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/widgets/side_menu_list_tile.dart';

class MySideMenu extends StatelessWidget {
  const MySideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                DrawerHeader(
                  child: Text('Header'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                SideMenuListTile(
                    tileText: 'Reminder',
                    tileIcon: Icon(Icons.alarm),
                    navRoute: ReminderScreenRoute),
                SideMenuListTile(
                    tileText: 'Summary',
                    tileIcon: Icon(Icons.pie_chart),
                    navRoute: SummaryScreenRoute),
                 SideMenuListTile(
                    tileText: 'Try Alarm',
                    tileIcon: Icon(Icons.access_alarm),
                    navRoute: ClockViewScreenRoute),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                title: const Text('Sign Out'),
                leading: const Icon(Icons.input),
                onTap: () async {
                  await AuthHelper.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignInScreenRoute, (route) => false);
                },
              )),
        ],
      ),
    );
  }
}
