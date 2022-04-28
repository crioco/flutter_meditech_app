import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class SideMenuListTile extends StatelessWidget {
  const SideMenuListTile({
    Key? key,
    required this.tileText,
    required this.navRoute,
    required this.tileIcon
  }) : super(key: key);

  final String tileText;
  final String navRoute;
  final String tileIcon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Iconify(tileIcon, color: const Color.fromARGB(255, 126, 126, 126), size: 28),
        title: Text(tileText, style: TextStyle(),),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, navRoute, (Route<dynamic> route) => false);
        });
  }
}
