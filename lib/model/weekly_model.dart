import 'dart:convert';
import 'package:flutter/services.dart';

/// این تابع فایل JSON رو از assets می‌خونه
Future<List<Map<String, dynamic>>> loadFlatWeeklySchedule() async {
  final String jsonString = await rootBundle.loadString('api/courses.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  return _convertWeeklySchedule(jsonData['weekly_schedule']);
}

/// این تابع داده‌های داخل weekly_schedule رو فلت می‌کنه
List<Map<String, dynamic>> _convertWeeklySchedule(List<dynamic> weeklySchedule) {
  final List<Map<String, dynamic>> result = [];

  for (var day in weeklySchedule) {
    String dayName = day['day_name'];
    List<dynamic> courses = day['courses'];
    for (var course in courses) {
      result.add({
        'day_name': dayName,
        'course_name': course['course_name'],
        'professor_name': course['professor_name'],
        'start_time': course['start_time'],
        'end_time': course['end_time'],
        'time': '${course['start_time']} - ${course['end_time']}',
        'course_status': course['course_status'],
        'exam_date': course['exam_date'],
        'department_name': course['department_name'],
        'classroom': course['classroom'],
      });
    }
  }

  return result;
}
