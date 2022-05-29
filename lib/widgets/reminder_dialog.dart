import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ReminderDialog extends StatefulWidget {
  const ReminderDialog(
      {Key? key,
      required this.mapItem,
      required this.docID,
      required this.time})
      : super(key: key);

  final List<Map<String, dynamic>> mapItem;
  final String docID;
  final String time;
  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  var mapCopy = [];
  @override
  initState() {
    super.initState();
    mapCopy = json.decode(json.encode(widget.mapItem));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      titlePadding: const EdgeInsets.all(5),
      title: Column(
        children: [
          const Text('Edit Alarm Intake'),
          Text(widget.time),
          const Divider(
            thickness: 1,
            height: 1,
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  mapCopy = json.decode(json.encode(widget.mapItem));
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
                style: ElevatedButton.styleFrom(
                      fixedSize: const Size(115, 30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      primary: Colors.grey)
            ),
            ElevatedButton(
                onPressed: () async {
                  Map<String, Map<String, dynamic>> nameMap = {};
                  for (var map in mapCopy) {
                    var pillName = map['pill_name'];
                    var dosage = map['dosage'];
                    var status = map['status'];
                    bool boolStatus;
                    if (status == 'Taken') {
                      boolStatus = true;
                    } else {
                      boolStatus = false;
                    }
                    nameMap[pillName] = {
                      'dosage': dosage,
                      'isTaken': boolStatus
                    };
                  }
                  var docRef = FirebaseFirestore.instance
                      .collection('DEVICE001')
                      .doc(widget.docID);
                  await docRef.update({'pills': nameMap, 'isMissed': false})
                  .then((value){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Data Has Been Updated'),
                    backgroundColor: Color.fromARGB(255, 74, 204, 79),
                    ));
                  })
                  .catchError((error){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Failed to Update Data'),
                    backgroundColor: Color.fromARGB(255, 196, 69, 69),
                    ));
                  });

                  Navigator.of(context).pop();               
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(115, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.blueAccent),
                child: const Text('CONFIRM'))
          ],
        )
      ],
      content: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mapCopy.length,
            itemBuilder: (context, index) {
              var map = mapCopy[index];
              var pillName = map['pill_name'];
              var dosage = map['dosage'];
              var status = map['status'];
              if (status == 'Missed') {status = 'Taken';}
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(dosage.toString()),
                      Text(pillName),
                      DropdownButton<String>(
                        value: status,
                        elevation: 8,
                        // style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        onChanged: (value) {
                          setState(() {
                            mapCopy[index]['status'] = value;
                          });
                        },
                        items: <String>['Taken', 'Skipped']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, height: 0)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}