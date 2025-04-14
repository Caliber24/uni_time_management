// lib/model/exam_model.dart
import 'package:flutter/material.dart';

class Exam {
  final String id;
  final String title;
  final String courseCode;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final String professor;
  final String educationalGroupId;
  final ExamType examType;

  Exam({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.professor,
    required this.educationalGroupId,
    required this.examType,
  });

  // Convert from JSON
  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      title: json['title'],
      courseCode: json['courseCode'],
      date: DateTime.parse(json['date']),
      startTime: _timeFromString(json['startTime']),
      endTime: _timeFromString(json['endTime']),
      location: json['location'],
      professor: json['professor'],
      educationalGroupId: json['educationalGroupId'],
      examType: ExamType.values.firstWhere(
            (e) => e.toString() == 'ExamType.${json['examType']}',
        orElse: () => ExamType.midterm,
      ),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseCode': courseCode,
      'date': date.toIso8601String(),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'location': location,
      'professor': professor,
      'educationalGroupId': educationalGroupId,
      'examType': examType.toString().split('.').last,
    };
  }

  // Helper method to convert string time to TimeOfDay
  static TimeOfDay _timeFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

// Educational Group model
class EducationalGroup {
  final String id;
  final String name;
  final String? description;
  final String? department;

  EducationalGroup({
    required this.id,
    required this.name,
    this.description,
    this.department,
  });

  // Convert from JSON
  factory EducationalGroup.fromJson(Map<String, dynamic> json) {
    return EducationalGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      department: json['department'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'department': department,
    };
  }
}

// Enum for exam types
enum ExamType {
  midterm,
  final_exam,
  quiz,
}

// Repository class to handle data operations
class ExamRepository {
  // Singleton pattern
  static final ExamRepository _instance = ExamRepository._internal();

  factory ExamRepository() {
    return _instance;
  }

  ExamRepository._internal();

  // Mock data for educational groups
  List<EducationalGroup> getEducationalGroups() {
    return [
      EducationalGroup(
        id: 'all',
        name: 'تمامی گروه های آموزشی',
      ),
      EducationalGroup(
        id: 'comp',
        name: 'مهندسی کامپیوتر',
        department: 'فنی و مهندسی',
      ),
      EducationalGroup(
        id: 'elec',
        name: 'مهندسی برق',
        department: 'فنی و مهندسی',
      ),
      EducationalGroup(
        id: 'mech',
        name: 'مهندسی مکانیک',
        department: 'فنی و مهندسی',
      ),
      EducationalGroup(
        id: 'sci',
        name: 'علوم پایه',
        department: 'علوم',
      ),
    ];
  }

  // Get exams filtered by group and type
  Future<List<Exam>> getExams({
    String? educationalGroupId,
    ExamType? examType,
  }) async {
    // In a real app, this would fetch from an API or database
    // For now, we'll return mock data
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

    List<Exam> allExams = _getMockExams();

    return allExams.where((exam) {
      bool matchesGroup = educationalGroupId == null ||
          educationalGroupId == 'all' ||
          exam.educationalGroupId == educationalGroupId;

      bool matchesType = examType == null || exam.examType == examType;

      return matchesGroup && matchesType;
    }).toList();
  }

  // Mock exam data
  List<Exam> _getMockExams() {
    return [
      Exam(
        id: '1',
        title: 'برنامه نویسی پیشرفته',
        courseCode: 'CS301',
        date: DateTime.now().add(const Duration(days: 5)),
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        location: 'کلاس ۱۰۱',
        professor: 'دکتر محمدی',
        educationalGroupId: 'comp',
        examType: ExamType.midterm,
      ),
      Exam(
        id: '2',
        title: 'مدارهای الکتریکی',
        courseCode: 'EE201',
        date: DateTime.now().add(const Duration(days: 7)),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        location: 'کلاس ۲۰۵',
        professor: 'دکتر رضایی',
        educationalGroupId: 'elec',
        examType: ExamType.midterm,
      ),
      Exam(
        id: '3',
        title: 'ریاضی مهندسی',
        courseCode: 'MATH301',
        date: DateTime.now().add(const Duration(days: 3)),
        startTime: const TimeOfDay(hour: 10, minute: 30),
        endTime: const TimeOfDay(hour: 12, minute: 30),
        location: 'سالن امتحانات',
        professor: 'دکتر کریمی',
        educationalGroupId: 'sci',
        examType: ExamType.final_exam,
      ),
      Exam(
        id: '4',
        title: 'استاتیک',
        courseCode: 'ME101',
        date: DateTime.now().add(const Duration(days: 10)),
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        location: 'کلاس ۳۰۲',
        professor: 'دکتر احمدی',
        educationalGroupId: 'mech',
        examType: ExamType.quiz,
      ),
    ];
  }
}

