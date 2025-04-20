import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_time_management/page/SelectUniver.dart';
import 'package:uni_time_management/page/ShowProfSchedule.dart';

class ProfessorSchedulePage extends StatefulWidget {
  final int universityId;
  final String universityName;
  final String selectedTerm;

  const ProfessorSchedulePage({
    Key? key,
    required this.universityId,
    required this.universityName,
    required this.selectedTerm,
  }) : super(key: key);

  @override
  _ProfessorSchedulePageState createState() => _ProfessorSchedulePageState();
}

class _ProfessorSchedulePageState extends State<ProfessorSchedulePage> {
  List<dynamic> _allSchedules = [];
  Map<String, String> _departmentNames = {};
  String? _selectedDepartment;
  String? _selectedProfessor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String jsonString = await rootBundle.loadString(
        'api/professors.json',
      );
      final jsonData = json.decode(jsonString);
      // print(jsonData);
      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey('faculty_schedule')) {
        List<dynamic> schedules = jsonData['faculty_schedule'];
        print(widget.selectedTerm);
        _allSchedules =
            schedules
                .where(
                  (schedule) =>
                      schedule['university_id'] == widget.universityId &&
                      schedule['semester'] == widget.selectedTerm,
                )
                .toList();

        _departmentNames = {
          for (var s in _allSchedules)
            s['department_code']: s['department_name'],
        };
      } else {
        print('Error: Invalid JSON structure');
      }
    } catch (e) {
      print('Error loading schedules: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavigationBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'انتخاب اساتید',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFF031A6B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'انتخاب اساتید',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 36),

                      /// گروه آموزشی
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'گروه آموزشی',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _selectedDepartment,
                        hint: 'تمامی گروههای آموزشی',
                        items: _getDepartmentItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                            _selectedProfessor = null;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      /// استاد
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'استاد',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _selectedProfessor,
                        hint: 'همه اساتید',
                        items: _getProfessorItems(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProfessor = value;
                          });
                        },
                      ),
                      const Spacer(),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 180,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF031A6B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: const Text(
                            'فیلتر کردن نتایج',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getDepartmentItems() {
    final departments = _departmentNames.entries.toList();
    return [
      const DropdownMenuItem<String>(
        value: null,
        child: Text('تمامی گروههای آموزشی'),
      ),
      ...departments.map(
        (entry) => DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        ),
      ),
    ];
  }

  List<DropdownMenuItem<String>> _getProfessorItems() {
    List<String> professors =
        _allSchedules
            .where(
              (schedule) =>
                  _selectedDepartment == null ||
                  schedule['department_code'] == _selectedDepartment,
            )
            .map((schedule) => schedule['professor_name'] as String)
            .toSet()
            .toList();

    return [
      const DropdownMenuItem<String>(value: null, child: Text('انتخاب استاد')),
      ...professors.map(
        (prof) => DropdownMenuItem<String>(value: prof, child: Text(prof)),
      ),
    ];
  }

  void _applyFilters() {
    List<dynamic> filtered =
        _allSchedules.where((schedule) {
          final matchesDept =
              _selectedDepartment == null ||
              schedule['department_code'] == _selectedDepartment;
          final matchesProf =
              _selectedProfessor == null ||
              schedule['professor_name'] == _selectedProfessor;
          return matchesDept && matchesProf;
        }).toList();

    Navigator.push(
      context,

      MaterialPageRoute(
        builder:
            (context) => ShowProfSchedule(
              universityId: widget.universityId,
              universityName: widget.universityName,
              selectedSemester: widget.selectedTerm,
              filteredSchedules: filtered,
            ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: const Color(0xFF031A6B),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      onTap: (index) {
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UniversityPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 18),
            child: Icon(Icons.settings),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 18),
            child: Icon(Icons.home),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 18),
            child: Icon(Icons.person),
          ),
          label: "",
        ),
      ],
    );
  }
}
