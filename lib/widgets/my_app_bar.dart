import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    required this.title,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        Container(),
      ],
    );
  }

  @override
  final Size preferredSize;
}
