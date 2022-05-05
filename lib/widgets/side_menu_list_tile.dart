import 'package:flutter/material.dart';

class SideMenuListTile extends StatelessWidget {
  const SideMenuListTile({
    Key? key,
    required this.tileText,
    required this.navRoute,
    required this.tileIcon
  }) : super(key: key);
  final String tileText;
  final String navRoute;
  final Icon tileIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: tileIcon,
        title: Text(tileText),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, navRoute, (Route<dynamic> route) => false);
        });
  }
}
