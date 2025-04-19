import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uni_time_management/page/DailyScheduleView.dart';
import 'package:uni_time_management/page/ExamSchedule.dart';
import 'package:uni_time_management/page/WeeklySchedule.dart';
import 'package:shamsi_date/shamsi_date.dart';

enum ScheduleType { daily, weekly, exam }

class ScheduleFilter extends StatefulWidget {
  final ScheduleType type;
  final dynamic universityId;
  final String? selectedSemester;

  const ScheduleFilter({
    Key? key,
    required this.type,
    required this.universityId,
    this.selectedSemester,
  }) : super(key: key);

  @override
  _ScheduleFilterState createState() => _ScheduleFilterState();

}

class _ScheduleFilterState extends State<ScheduleFilter> {
  String? selectedEducationalGroup;
  dynamic selectedUniversityId;
  List<String> educationalGroups = ['تمامی گروه های آموزشی'];
  List<Map<String, dynamic>> allSchedules = [];
  List<Map<String, dynamic>> universities = [];
  String filterTitle = '';
  bool isLoading = true;
  String universityName = '';

  bool _compareIds(dynamic id1, dynamic id2) {
    if (id1 == null || id2 == null) return false;
    String strId1 = id1.toString();
    String strId2 = id2.toString();
    return strId1 == strId2;
  }

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case ScheduleType.daily:
        filterTitle = 'فیلتر برنامه روزانه';
        break;
      case ScheduleType.weekly:
        filterTitle = 'فیلتر برنامه هفتگی';
        break;
      case ScheduleType.exam:
        filterTitle = 'فیلتر برنامه امتحانی';
        break;
    }

    selectedUniversityId = widget.universityId;

    _loadUniversities();
  }

  Future<void> _loadUniversities() async {
    try {
      final String uniResponse = await rootBundle.loadString('api/university.json');
      final Map<String, dynamic> uniData = json.decode(uniResponse);
      universities = List<Map<String, dynamic>>.from(uniData['universities']);

      var selectedUni = universities.firstWhere(
            (uni) => _compareIds(uni['id'], selectedUniversityId),
        orElse: () => {'name': 'دانشگاه نامشخص'},
      );

      setState(() {
        universityName = selectedUni['name'];
      });

      await _loadSchedules();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در بارگذاری دانشگاه‌ها: $e')),
      );
    }
  }

  Future<void> _loadSchedules() async {
    if (selectedUniversityId == null) return;

    setState(() {
      isLoading = true;
      educationalGroups = ['تمامی گروه های آموزشی'];
      allSchedules = [];
    });

    try {
      final String depResponse = await rootBundle.loadString('api/dep.json');
      final Map<String, dynamic> depData = json.decode(depResponse);
      List<Map<String, dynamic>> allDeps = List<Map<String, dynamic>>.from(depData['departments']);

      List<Map<String, dynamic>> departments = allDeps
          .where((dep) => _compareIds(dep['university_id'], selectedUniversityId))
          .toList();

      final String profResponse = await rootBundle.loadString('api/professors.json');
      final Map<String, dynamic> profData = json.decode(profResponse);
      List<Map<String, dynamic>> allProfs = List<Map<String, dynamic>>.from(profData['faculty_schedule']);

      List<Map<String, dynamic>> profSchedules = allProfs
          .where((prof) => _compareIds(prof['university_id'], selectedUniversityId))
          .toList();

      Set<String> additionalDepartments = profSchedules
          .map((e) => e['department_name'] as String)
          .toSet();

      Set<String> departmentNames = departments
          .map((dep) => dep['department_name'] as String)
          .toSet();

      educationalGroups = [
        'تمامی گروه های آموزشی',
        ...departmentNames,
        ...additionalDepartments.difference(departmentNames)
      ];

      if (widget.type == ScheduleType.exam) {
        final String examResponse = await rootBundle.loadString('api/exam.json');
        final Map<String, dynamic> examData = json.decode(examResponse);
        List<Map<String, dynamic>> allExams = List<Map<String, dynamic>>.from(examData['courses_exam']);

        List<Map<String, dynamic>> examSchedules = allExams
            .where((exam) => _compareIds(exam['university_id'], selectedUniversityId))
            .toList();

        print(examSchedules);

        allSchedules = examSchedules.map((schedule) {
          return {
            'course_name': schedule['course_name'] ?? 'تعیین نشده',
            'department_name': schedule['department_name'] ?? 'تعیین نشده',
            'exam_date': schedule['exam_date'] ?? 'تعیین نشده',
            'time': schedule['exam_time'] ?? 'تعیین نشده',
            'day_name': schedule['day_name'] ?? 'تعیین نشده',
            'professor_name': schedule['professor_name'] ?? 'تعیین نشده',
          };
        }).toList();
      } else {
        final String coursesResponse = await rootBundle.loadString('api/courses.json');
        final Map<String, dynamic> coursesData = json.decode(coursesResponse);
        List<Map<String, dynamic>> allCourses = List<Map<String, dynamic>>.from(coursesData['weekly_schedule']);

        List<Map<String, dynamic>> weeklySchedules = allCourses
            .where((course) => _compareIds(course['university_id'], selectedUniversityId))
            .toList();

        if (widget.selectedSemester != null) {
          weeklySchedules = weeklySchedules
              .where((course) => course['semester'] == widget.selectedSemester)
              .toList();
        }

        allSchedules = [];

        for (var course in weeklySchedules) {
          String courseStatus = course['course_status'] ?? 'تعیین نشده';
          var matchingProf = profSchedules.firstWhere(
                (prof) =>
            prof['course_name'] == course['course_name'] &&
                prof['department_name'] == course['department_name'] &&
                prof['day_name'] == course['day_name'],
            orElse: () => {'status': courseStatus},
          );
          courseStatus = matchingProf['status'] ?? courseStatus;

          allSchedules.add({
            'course_name': course['course_name'] ?? 'تعیین نشده',
            'department_name': course['department_name'] ?? 'تعیین نشده',
            'start_time': course['start_time'] ?? 'تعیین نشده',
            'end_time': course['end_time'] ?? 'تعیین نشده',
            'day_name': course['day_name'] ?? 'تعیین نشده',
            'professor_name': course['professor_name'] ?? 'تعیین نشده',
            'classroom': course['classroom'] ?? 'تعیین نشده',
            'course_status': courseStatus,
          });
        }

        if (widget.type == ScheduleType.daily) {
          final now = DateTime.now();
          final jalaliDate = Jalali.fromDateTime(now);
          const List<String> dayNames = ['شنبه', 'یکشنبه', 'دوشنبه', 'سهشنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه'];
          String todayDayName = dayNames[jalaliDate.weekDay % 7];
          allSchedules = allSchedules.where((schedule) => schedule['day_name'] == todayDayName).toList();
        }
      }

      if (allSchedules.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('هیچ برنامه‌ای برای این دانشگاه یافت نشد')),
        );
      }

      setState(() {
        selectedEducationalGroup = educationalGroups[0];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در بارگذاری داده‌ها: $e')),
      );
    }
  }

  List<Map<String, dynamic>> _filterSchedules() {
    if (selectedEducationalGroup == 'تمامی گروه های آموزشی') {
      return allSchedules;
    }

    return allSchedules
        .where((schedule) => schedule['department_name'] == selectedEducationalGroup)
        .toList();
  }

  String _getScheduleTypeText(ScheduleType type) {
    switch (type) {
      case ScheduleType.daily:
        return 'برنامه روزانه';
      case ScheduleType.weekly:
        return 'برنامه هفتگی';
      case ScheduleType.exam:
        return 'برنامه امتحانی';
    }
  }

  IconData _getScheduleTypeIcon(ScheduleType type) {
    switch (type) {
      case ScheduleType.daily:
        return Icons.today;
      case ScheduleType.weekly:
        return Icons.calendar_view_week;
      case ScheduleType.exam:
        return Icons.assignment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '$filterTitle - $universityName',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF031A6B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _getScheduleTypeIcon(widget.type),
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getScheduleTypeText(widget.type),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.filter_list, color: Color(0xff1a2b8a)),
                              const SizedBox(width: 5),
                              Text(
                                'گروه آموزشی',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff1a2b8a),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF00137B), width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                prefixIcon: const Icon(
                                  Icons.filter_list,
                                  color: Color(0xFF1A2B8A),
                                  size: 20,
                                ),
                              ),
                              value: selectedEducationalGroup,
                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1A2B8A), size: 28),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A2B8A),
                              ),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              elevation: 4,
                              itemHeight: 50,
                              items: educationalGroups.map((group) {
                                return DropdownMenuItem<String>(
                                  value: group,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Text(
                                      group,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1A2B8A),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedEducationalGroup = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: 180,
                            child: ElevatedButton(
                              onPressed: () {
                                final filteredSchedules = _filterSchedules();
                                Widget destination;
                                switch (widget.type) {
                                  case ScheduleType.daily:
                                    destination = DailyScheduleView(
                                      filteredSchedules: filteredSchedules,
                                    );
                                    break;
                                  case ScheduleType.weekly:
                                    destination = WeeklyScheduleView(
                                      filteredSchedules: filteredSchedules,
                                    );
                                    break;
                                  case ScheduleType.exam:
                                    destination = ExamScheduleView(
                                      filteredSchedules: filteredSchedules,
                                    );
                                    break;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => destination),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff1a2b8a),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'فیلتر کردن نتایج',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFF00137B),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
