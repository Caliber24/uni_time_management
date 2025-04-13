import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class ShowProfSchedule extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ShowProfSchedule> {
  List<String> selectedDays = [];
  List<dynamic> facultySchedule = [];

  Future<void> loadData() async {
    final String response = await rootBundle.loadString(
        'assets/api/professors.json');
    final data = await json.decode(response);
    setState(() {
      facultySchedule = data['faculty_schedule'];
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }


  List<Map<String, dynamic>> _filterScheduleBySelectedDays() {
    return facultySchedule
        .where((schedule) => selectedDays.contains(schedule['day']))
        .map((schedule) {
      return {
        'course_name': schedule['course_name'],
        'time': schedule['time'],
        'professor_name': schedule['professor_name'],
        'day': schedule['day'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: facultySchedule.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            //   بخش انتخاب روز ها
            Padding(
              padding: const EdgeInsets.all(8.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDayButton('شنبه'),
                  _buildDayButton('یکشنبه'),
                  _buildDayButton('دوشنبه'),
                  _buildDayButton('سه شنبه'),
                  _buildDayButton('چهارشنبه'),
                ],
              ),
            )
          ],
        )
    );
  }

  Widget _buildDayButton(String day) {
    bool isSelected = selectedDays.contains(day);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedDays.remove(day);
          } else {
            selectedDays.add(day);
          }
        });
      },
      child: Text(day),
      style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey),);
  }
}