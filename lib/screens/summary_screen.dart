import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/model/alarm_object.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';
import 'package:intl/intl.dart';
import 'package:flutter_meditech_app/const/global_functions.dart';

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
    final timeNow = DateTime.now();
    var dataList = [
      getData(context, DateTime(2022, 4, 4)),
      getData(context, DateTime(2022, 4, 5)),
      getData(context, DateTime(2022, 4, 6)),
      getData(context, DateTime(2022, 4, 7)),
      getData(context, DateTime(2022, 4, 8)),
      getData(context, DateTime(2022, 4, 9)),
      getData(context, DateTime(2022, 4, 11)),
    ];
    // var data = getData(DateTime(2022, 4, 11));

    return Scaffold(
      appBar: const MyAppBar(title: 'Summary'),
      drawer: MySideMenu(),
      body: Center(
        child: Column(
          children: [
            Text(DateFormat('EEEE, MMM d y').format(timeNow)),
            Expanded(
              // child: Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: FutureBuilder(
              //       future: data,
              //       builder: (BuildContext context, AsyncSnapshot<List<AlarmObject>> snapshot) {
              //         if (snapshot.hasData) {
              //           return Text(snapshot.data.toString());
              //         }
              //         return Container();
              //       }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: StreamBuilder<QuerySnapshot>(
                    stream: getData(context, DateTime(2022, 4, 4)),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data!.docs.map(
                            (DocumentSnapshot document) {
                              var data =
                                  document.data()! as Map<String, dynamic>;
                              var isSkipped = data['isSkipped'];
                              var alarmTime = data['alarmTime']
                                  .toDate()
                                  .add(const Duration(hours: 8));
                              var takenTime = data['takenTime']
                                  .toDate()
                                  .add(const Duration(hours: 8));
                              var pills = data['pills'];

                              // print('Skipped: $isSkipped');
                              // print('Alarm Time: $alarmTime');
                              // print('Taken Time: $takenTime');
                              // print('Pill List: $pills');
                              return Text(alarmTime.toString());
                            },
                          ).toList(),
                        );
                      }
                      return Container();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<List<AlarmObject>> getData(DateTime docDate) async {
  //   try {
  //     return await FirebaseFirestore.instance
  //         .collection('DEVICE001')
  //         .where('alarmTime', isGreaterThan: docDate)
  //         .where('alarmTime', isLessThan: docDate.add(const Duration(days: 1)))
  //         .get()
  //         .then((value) =>
  //             value.docs.map((doc) => AlarmObject.fromSnapshot(doc)).toList());
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Stream<QuerySnapshot> getData(BuildContext context, DateTime docDate) async* {
    yield* FirebaseFirestore.instance
        .collection('DEVICE001')
        .where('alarmTime', isGreaterThan: docDate)
        .where('alarmTime', isLessThan: docDate.add(const Duration(days: 1)))
        .snapshots();
  }
}
