import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final Stream<QuerySnapshot> dataStream =
      FirebaseFirestore.instance.collection('DEVICE001').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Summary'),
      drawer: MySideMenu(),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: dataStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      var data = document.data()! as Map<String, dynamic>;
                      var isSkipped = data['isSkipped'];
                      print(isSkipped);
                      var alarmTime = data['alarmTime'];
                      var pills = data['pills'];
                      print(isSkipped);
                      print(alarmTime);
                      print(pills);
                      return const Text('Text');
                    },
                  ).toList(),
                );
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
