import 'package:flutter/material.dart';

class SideMenuListTile extends StatelessWidget {
  const SideMenuListTile({
    Key? key,
    required this.tileText,
    required this.navRoute,
  }) : super(key: key);
  final String tileText;
  final String navRoute;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(tileText),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, navRoute, (Route<dynamic> route) => false);
        });
  }
}
