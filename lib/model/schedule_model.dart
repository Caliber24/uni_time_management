// lib/model/schedule_model.dart
class ClassSchedule {
  final String group;
  final String courseCode;
  final String courseTitle;
  final String classTime;
  final String status; // "برگزار" or "لغو"

  ClassSchedule({
    required this.group,
    required this.courseCode,
    required this.courseTitle,
    required this.classTime,
    required this.status,
  });

  // Convert from JSON
  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule(
      group: json['group'],
      courseCode: json['courseCode'],
      courseTitle: json['courseTitle'],
      classTime: json['classTime'],
      status: json['status'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'group': group,
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'classTime': classTime,
      'status': status,
    };
  }
}