import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';
import 'package:intl/intl.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final Stream<QuerySnapshot> dataStream = FirebaseFirestore.instance.collection('DEVICE001').snapshots();
  List<Stream<QuerySnapshot>> streamList = [];

  @override
  Widget build(BuildContext context) {
    final timeNow = DateTime.now();

    return Scaffold(
      appBar: const MyAppBar(title: 'Summary'),
      drawer: MySideMenu(),
      body: Center(
        child: Column(
          children: [
            Text(DateFormat('EEEE, MMM d y').format(timeNow)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: StreamBuilder<QuerySnapshot>(
                    stream: dataStream,
                    builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                              var data = document.data()! as Map<String, dynamic>;
                              var isSkipped = data['isSkipped'];
                              var alarmTime = data['alarmTime'].toDate().add(const Duration(hours: 8));
                              var takenTime = data['takenTime'].toDate().add(const Duration(hours: 8));
                              var pills = data['pills'];
            
                              print('Skipped: $isSkipped');
                              print('Alarm Time: $alarmTime');
                              print('Taken Time: $takenTime');
                              print('Pill List: $pills');
                              return Text(alarmTime.toString());
                            },
                          ).toList(),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
