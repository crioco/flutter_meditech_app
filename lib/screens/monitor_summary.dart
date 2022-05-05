import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';
import 'package:intl/intl.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MonitorSummary extends StatefulWidget {
  const MonitorSummary({Key? key,
  }) : super(key: key);

  @override
  State<MonitorSummary> createState() => _MonitorSummaryState();
}

class _MonitorSummaryState extends State<MonitorSummary> {
  var dataList = [];
  var totalPills = 0;
  var missedPills = 0;
  var skippedPills = 0;
  var takenPills = 0;
  var noDataFound = false;
  final timeNow = DateTime.now();
  var displayTime = DateTime.now();
  List<DateTime> dateList = getDateList(DateTime.now());

  String deviceID = DataSharedPreferences.getMonitorID();

  _MonitorSummaryState() {
    getDataList(dateList).then((value) => setState(() {
      dataList = value;

      countPills().then((value) => setState(() {
          }));
    }));
}

  Future<void> updateDateList() async {
    dataList = await getDataList(dateList);
  }

  Future<void> countPills() async {
    totalPills = 0;
    missedPills = 0;
    skippedPills = 0;
    takenPills = 0;

    if (dataList.isNotEmpty) {
      for (var list in dataList) {
        QuerySnapshot querySnap = await list[0]; // QuerySnapshot
        var docsList = querySnap.docs; // List<QueryDocumentSnapshots

        for (var docSnap in docsList) {
          // DocumentSnapshot
          var map =
              docSnap.data() as Map<String, dynamic>; // Map<String, dynamic>
          var pills = map['pills'] as Map<String, dynamic>;
          var isMissed = map['isMissed'];

          for (var i = 0; i < pills.length; i++) {
            var mapValue = pills.values.elementAt(i);

            var dosage = mapValue['dosage'] as int;
            var isTaken = mapValue['isTaken'];

            if (isTaken && !isMissed) {
              takenPills += dosage;
              totalPills += dosage;
            } else if (!isTaken && isMissed) {
              missedPills += dosage;
              totalPills += dosage;
            } else {
              skippedPills += dosage;
              totalPills += dosage;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Summary'),
      drawer: const MySideMenu(),
      body: (deviceID != 'NULL') 
      ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: (dataList.isEmpty && noDataFound == false)
                  ? 
                  [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 160,
                      child: const Center(
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: CircularProgressIndicator(
                            strokeWidth: 8,
                          )))),
                    ]:
                  [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          title: Text(
                            DateFormat('EEEE, MMM d y').format(displayTime),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                currentTime: displayTime,
                                showTitleActions: true,
                                minTime: DateTime(2022, 1, 1),
                                maxTime: timeNow,
                                onChanged: (date) {}, onConfirm: (date) {
                              setState(() {
                                displayTime = date;
                                dateList = getDateList(date);
                              });
                              updateDateList().then((value) => setState(
                                    () {
                                      countPills()
                                          .then((value) => setState(() {}));
                                    },
                                  ));
                            }, onCancel: () {});
                          },
                        ),
                      ),
                      Column(
                          children: (dataList.isEmpty)
                              ? [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height - 210,
                                    child: const Center(
                                        child: SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: Text('No Data'),
                                    )),
                                  )
                                ]
                              : [
                                  Text(getWeekRange(displayTime)),
                                  Text(
                                      'Total Pills: $totalPills, Taken: $takenPills Missed: $missedPills Skipped: $skippedPills'),
                                  CircularPercentIndicator(
                                    radius: 70,
                                    lineWidth: 20,
                                    animation: true,
                                    animationDuration: 800,
                                    percent: takenPills / totalPills,
                                    center: Text(
                                      '${((takenPills / totalPills) * 100).round().toString()}%',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    footer: const Text(
                                      'Weekly Adherence',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.blue[800],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: dataList.map((dataList) {
                                        var date = dataList[1] as DateTime;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: ExpansionTileCard(
                                            title: Text(
                                                DateFormat('EEEE, MMM d')
                                                    .format(date)),
                                            children: [
                                              const Divider(
                                                thickness: 1.0,
                                                height: 1.0,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: FutureBuilder<
                                                        QuerySnapshot>(
                                                    future: dataList[0]
                                                        as Future<
                                                            QuerySnapshot>,
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                QuerySnapshot>
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        return ListView(
                                                          physics:const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          children: snapshot
                                                              .data!.docs
                                                              .map(
                                                            (DocumentSnapshot
                                                                document) {
                                                              var data = document
                                                                      .data()!
                                                                  as Map<String,
                                                                      dynamic>;
                                                              var isMissed = data[
                                                                  'isMissed'];
                                                              var alarmTime = data[
                                                                      'alarmTime']
                                                                  .toDate();
                                                              var pills = data[
                                                                      'pills']
                                                                  as Map<String,
                                                                      dynamic>;

                                                              return Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(DateFormat(
                                                                          'jm')
                                                                      .format(
                                                                          alarmTime)),
                                                                  ListView
                                                                      .builder(
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: pills
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      var pillName = pills
                                                                          .keys
                                                                          .elementAt(
                                                                              index);
                                                                      var map =
                                                                          pills[
                                                                              pillName];
                                                                      var dosage =
                                                                          map['dosage']
                                                                              as int;
                                                                      var isTaken =
                                                                          map['isTaken'];
                                                                      String
                                                                          status;

                                                                      if (isTaken &&
                                                                          !isMissed) {
                                                                        status =
                                                                            'Taken';
                                                                      } else if (isMissed &&
                                                                          !isTaken) {
                                                                        status =
                                                                            'Missed';
                                                                      } else {
                                                                        status =
                                                                            'Skipped';
                                                                      }

                                                                      return Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(dosage
                                                                              .toString()),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                              pillName),
                                                                          const SizedBox(
                                                                            width:
                                                                                30,
                                                                          ),
                                                                          Text(
                                                                              status),
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
                                                      return Container();
                                                    }),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ]),
                    ]
                  ),
        ),
      )
      :  const Center(
          child: SizedBox(
        height: 70,
        width: 200,
        child: Text('No Device Registered'),
      )),
    );
  }

  Future<QuerySnapshot<Object?>> getQuerySnapshot(DateTime date) {
    return FirebaseFirestore.instance
        .collection(deviceID)
        .where('alarmTime',
            isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day))
        .where('alarmTime',
            isLessThan: DateTime(date.year, date.month, date.day)
                .add(const Duration(days: 1)))
        .orderBy('alarmTime', descending: false)
        .get();
  }

  Future<List<List<Object>>> getDataList(List<DateTime> dateList) async {
    List<List<Object>> dataList = [];
    for (var date in dateList) {
      QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
          .instance
          .collection(deviceID)
          .where('alarmTime',
              isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day))
          .where('alarmTime',
              isLessThan: DateTime(date.year, date.month, date.day)
                  .add(const Duration(days: 1)))
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        dataList.add([getQuerySnapshot(date), date]);
      }
    }
    if (dataList.isEmpty) {
      noDataFound = true;
    }
    return dataList;
  }
}

List<DateTime> getDateList(DateTime date) {
  var recentMonday =
      DateTime(date.year, date.month, date.day - (date.weekday - 1));
  List<DateTime> tempList = [];

  for (var i = 0; i < 7; i++) {
    tempList.add(recentMonday.add(Duration(days: i)));
  }

  return tempList;
}

String getWeekRange(DateTime date) {
  var recentMonday =
      DateTime(date.year, date.month, date.day - (date.weekday - 1));
  var nextSunday = recentMonday.add(const Duration(days: 6));

  return '${DateFormat('MMM d').format(recentMonday)} - ${DateFormat('MMM d').format(nextSunday)}';
}
