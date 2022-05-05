import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmInfo{
int? id;
  String? title;
  DateTime? alarmDateTime;
  bool? isPending;
  int? gradientColorIndex;
  String? alarmLabel;
  
  AlarmInfo (
    {  this.id,
       this.title,
       this.alarmDateTime,
       this.isPending,
       this.gradientColorIndex,
       this.alarmLabel
       });

factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
        id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        isPending: json["isPending"],
        gradientColorIndex: json["gradientColorIndex"],
        alarmLabel: json["alarmLabel"],
      );

   Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime!.toIso8601String(),
        "isPending": isPending,
        "gradientColorIndex": gradientColorIndex,
        "alarmLabel":alarmLabel
      };
}     
