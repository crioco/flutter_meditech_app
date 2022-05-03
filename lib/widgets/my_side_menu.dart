import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/auth_helper.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/widgets/side_menu_list_tile.dart';
import 'package:iconify_flutter/icons/fluent.dart';
import 'package:provider/provider.dart';

class MySideMenu extends StatelessWidget {
  const MySideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 160,
                child: DrawerHeader(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                tileIcon: Fluent.clock_alarm_24_filled,
                navRoute: ReminderScreenRoute,
              ),
              const SideMenuListTile(
                tileText: 'Summary',
                tileIcon: Fluent.data_pie_24_filled,
                navRoute: SummaryScreenRoute,
              ),
              const SideMenuListTile(
                tileText: 'Pill Settings',
                tileIcon: Fluent.pill_24_filled,
                navRoute: PillSettingsScreenRoute,
              ),
              const SideMenuListTile(
                tileText: 'Monitoring',
                tileIcon: Fluent.clipboard_task_list_rtl_24_filled,
                navRoute: MonitoringScreenRoute,
              ),
              const SideMenuListTile(
                tileText: 'My Account',
                tileIcon: Fluent.person_circle_24_filled,
                navRoute: AccountScreenRoute,
              )
            ],
          ),
          const Expanded(child: SizedBox()),
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
