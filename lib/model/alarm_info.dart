class AlarmInfo{
  late DateTime alarmDateTime;
  String description;
  late bool isActive;

  AlarmInfo(this.alarmDateTime,{required this.description});
}
List<AlarmInfo> alarms =[
  AlarmInfo(DateTime.now().add(Duration(hours: 1)), description:'Medicine a'),
  AlarmInfo(DateTime.now().add(Duration(hours: 2)), description:'Sport'),
];