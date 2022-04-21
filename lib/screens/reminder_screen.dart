import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';

var monday = [
  {
    'time': '7:00 PM',
    'list': [
      {'pill': 'Vitamin C', 'dosage': 2},
      {'pill': 'Vitamin A', 'dosage': 1},
    ],
  },
  {
    'time': '6:00 PM',
    'list': [
      {'pill': 'Vitamin C', 'dosage': 2},
    ],
  },
  {
    'time': '8:00 PM',
    'list': [
      {'pill': 'Vitamin C', 'dosage': 2},
    ],
  },
  {
    'time': '1:00 PM',
    'list': [
      {'pill': 'Vitamin C', 'dosage': 2},
    ],
  },
  {
    'time': '2:00 PM',
    'list': [
      {'pill': 'Vitamin C', 'dosage': 2},
    ],
  },
];

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Reminder'),
      drawer: MySideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 40),
                child: Text(
                  'Monday, April 11',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              ExpansionPanelList.radio(
                children: monday.map((panel) {
                  return ExpansionPanelRadio(
                    canTapOnHeader: true,
                    value: panel['time'] as String,
                    headerBuilder: (context, isExpanded) {
                      return Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            panel['time'] as String,
                          ));
                    },
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: 100,
                          child: ListView.builder(
                            itemCount:
                                (panel['list'] as List<Map<String, Object>>)
                                    .length,
                            itemBuilder: (context, index) {
                              var pillList = (panel['list']
                                  as List<Map<String, Object>>)[index];
                              // Replace with Column
                              return Text(
                                  '${pillList['dosage']}  ${pillList['pill']}');
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              print(panel['time'] as String);
                            },
                            child: const Text('Edit'),
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
