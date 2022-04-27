import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/auth_helper.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/widgets/side_menu_list_tile.dart';
import 'package:provider/provider.dart';

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
              children: [
                SizedBox(
                  height: 150,
                  child: DrawerHeader(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(Provider.of<DataProvider>(
                            context, listen: false).firstName, 
                            style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 5,),
                          Text(Provider.of<DataProvider>(
                            context, listen: false).lastName, 
                            style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SideMenuListTile(
                    tileText: 'Reminder',
                    tileIcon: Icon(Icons.alarm),
                    navRoute: ReminderScreenRoute),
                const SideMenuListTile(
                    tileText: 'Summary',
                    tileIcon: Icon(Icons.pie_chart),
                    navRoute: SummaryScreenRoute),
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
