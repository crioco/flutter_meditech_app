import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';
import 'package:intl/intl.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  var dataList = [];
  // var buildTimes = 0;

  var totalPills = 0;
  var missedPills = 0;
  var skippedPills = 0;
  var takenPills = 0;

  List<DateTime> dateList = [
    DateTime(2022, 4, 4),
    DateTime(2022, 4, 5),
    DateTime(2022, 4, 6),
    DateTime(2022, 4, 7),
    DateTime(2022, 4, 8),
    DateTime(2022, 4, 11),
    DateTime(2022, 4, 12),
  ];

  _SummaryScreenState() {
    getDataList(dateList).then((value) => setState(() {
          dataList = value;
          // print('[List Rebuild]');

          countPills().then((value) => setState(() {
                //  print('[Count Rebuild]');
              }));
        }));
  }

  // void afterBuild() {
  //   buildTimes++;
  //   if (buildTimes == 2) {
  //     Timer(const Duration(milliseconds: 100), () {
  //       setState(() {
  //         // print(totalPills);
  //       });
  //     });
  //   }
  //   print('After | $buildTimes');
  // }

  Future<void> countPills() async {
    if (dataList.isNotEmpty) {
      for (var list in dataList) {
        QuerySnapshot querySnap = await list[0]; // QuerySnapshot
        var docsList = querySnap.docs; // List<QueryDocumentSnapshots

        for (var docSnap in docsList) {
          // DocumentSnapshot
          var map =
              docSnap.data() as Map<String, dynamic>; // Map<String, dynamic>
          var pills = map['pills'] as Map<String, dynamic>;
          var isSkipped = map['isSkipped'];

          for (var i = 0; i < pills.length; i++) {
            var mapValue = pills.values.elementAt(i);

            var dosage = mapValue['dosage'] as int;
            var isTaken = mapValue['isTaken'];

            if (isTaken && !isSkipped) {
              takenPills += dosage;
              totalPills += dosage;
            } else if (!isTaken && isSkipped) {
              skippedPills += dosage;
              totalPills += dosage;
            } else {
              missedPills += dosage;
              totalPills += dosage;
            }
          }
        }
      }
    }
    // print('[Count Done]');
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) => afterBuild());
    final timeNow = DateTime.now();

    // var dataList = [
    //   [getStream(context, DateTime(2022, 4, 4)), DateTime(2022, 4, 4)],
    //   [getStream(context, DateTime(2022, 4, 5)), DateTime(2022, 4, 5)],
    //   [getStream(context, DateTime(2022, 4, 6)), DateTime(2022, 4, 6)],
    //   [getStream(context, DateTime(2022, 4, 7)), DateTime(2022, 4, 7)],
    //   [getStream(context, DateTime(2022, 4, 8)), DateTime(2022, 4, 8)],
    //   [getStream(context, DateTime(2022, 4, 9)), DateTime(2022, 4, 9)],
    //   [getStream(context, DateTime(2022, 4, 11)), DateTime(2022, 4, 11)],
    // ];

    return Scaffold(
      appBar: const MyAppBar(title: 'Summary'),
      drawer: MySideMenu(),
      body: Center(
        child: Column(
            children: (dataList.isNotEmpty)
                ? [
                    Text(DateFormat('EEEE, MMM d y').format(timeNow)),
                    Text(
                        'Total Pills: $totalPills, Taken: $takenPills Missed: $missedPills Skipped: $skippedPills'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          // physics: const NeverScrollableScrollPhysics(),
                          child: ListView(
                            shrinkWrap: true,
                            children: dataList.map((dataList) {
                              var date = dataList[1] as DateTime;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ExpansionTileCard(
                                  title: Text(
                                      DateFormat('EEEE, MMM d y').format(date)),
                                  children: [
                                    const Divider(
                                      thickness: 1.0,
                                      height: 1.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: FutureBuilder<QuerySnapshot>(
                                          future: dataList[0]
                                              as Future<QuerySnapshot>,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return ListView(
                                                shrinkWrap: true,
                                                children:
                                                    snapshot.data!.docs.map(
                                                  (DocumentSnapshot document) {
                                                    var data = document.data()!
                                                        as Map<String, dynamic>;
                                                    var isSkipped =
                                                        data['isSkipped'];
                                                    var alarmTime =
                                                        data['alarmTime']
                                                            .toDate()
                                                            .add(const Duration(
                                                                hours: 8));
                                                    var takenTime =
                                                        data['takenTime']
                                                            .toDate()
                                                            .add(const Duration(
                                                                hours: 8));
                                                    var pills = data['pills']
                                                        as Map<String, dynamic>;

                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(DateFormat('jm')
                                                            .format(alarmTime)),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              pills.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            var pillName = pills
                                                                .keys
                                                                .elementAt(
                                                                    index);
                                                            var map =
                                                                pills[pillName];
                                                            var dosage =
                                                                map['dosage']
                                                                    as int;
                                                            var isTaken =
                                                                map['isTaken'];
                                                            String status;

                                                            if (isTaken &&
                                                                !isSkipped) {
                                                              status = 'Taken';
                                                              // takenPills += dosage;
                                                              // totalPills += dosage;
                                                            } else if (!isTaken &&
                                                                isSkipped) {
                                                              status =
                                                                  'Skipped';
                                                              // skippedPills += dosage;
                                                              // totalPills += dosage;
                                                            } else {
                                                              status = 'Missed';
                                                              // missedPills += dosage;
                                                              // totalPills += dosage;
                                                            }

                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(dosage
                                                                    .toString()),
                                                                Text(pillName),
                                                                Text(status),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ).toList(),
                                              );
                                            }
                                            return const Text('Loading');
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ]
                : [
                    const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                  ]),
      ),
    );
  }

  Future<QuerySnapshot<Object?>> getQuerySnapshot(DateTime docDate) async {
    return FirebaseFirestore.instance
        .collection('DEVICE001')
        .where('alarmTime', isGreaterThan: docDate)
        .where('alarmTime', isLessThan: docDate.add(const Duration(days: 1)))
        .orderBy('alarmTime', descending: true)
        .get();
  }

  Future<List<List<Object>>> getDataList(List<DateTime> dateList) async {
    List<List<Object>> dataList = [];
    for (var date in dateList) {
      QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
          .instance
          .collection('DEVICE001')
          .where('alarmTime', isGreaterThan: date)
          .where('alarmTime', isLessThan: date.add(const Duration(days: 1)))
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        dataList.add([getQuerySnapshot(date), date]);
      }
      // print(dataList.toString());
    }
    // print('[List Done]');
    return dataList;
  }
}
