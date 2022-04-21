import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmObject {
  final DateTime alarmTime;
  final DateTime takenTime;
  final bool isSkipped;
  final Map<String, Map<String, Object>> pills;

  AlarmObject({
    required this.alarmTime,
    required this.takenTime,
    required this.isSkipped,
    required this.pills,
  });

  AlarmObject.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : alarmTime = snapshot.data()['alarmTime'],
        takenTime = snapshot.data()['takenTime'],
        isSkipped = snapshot.data()['isSkipped'],
        pills = snapshot.data()['pills'];
}
