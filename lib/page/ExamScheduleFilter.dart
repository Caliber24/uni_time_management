import 'package:flutter/material.dart';

class ExamScheduleFilter extends StatefulWidget {
  const ExamScheduleFilter({Key? key}) : super(key: key);

  @override
  _ExamScheduleFilterState createState() => _ExamScheduleFilterState();
}

class _ExamScheduleFilterState extends State<ExamScheduleFilter> {
  String selectedEducationalGroup = 'تمامی گروه های آموزشی';
  String selectedExamType = 'میان ترم';

  // Lists for dropdown items
  final List<String> educationalGroups = [
    'تمامی گروه های آموزشی',
    'مهندسی کامپیوتر',
    'مهندسی برق',
    'مهندسی مکانیک',
    'علوم پایه',
  ];

  final List<String> examTypes = [
    'میان ترم',
    'پایان ترم',
    'کوییز',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF001F6B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'برنامه امتحانی',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Educational Group Section
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'گروه آموزشی',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Educational Group Dropdown
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedEducationalGroup,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedEducationalGroup = newValue!;
                        });
                      },
                      items: educationalGroups
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Exam Type Section
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'نوع',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Exam Type Dropdown
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedExamType,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedExamType = newValue!;
                        });
                      },
                      items: examTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Filter Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your filter logic here
                      print('Educational Group: $selectedEducationalGroup');
                      print('Exam Type: $selectedExamType');
                      // Navigate to results or update current view
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001F6B),
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

                // Spacer to push navigation bar to bottom
                const Spacer(),

                // Bottom Navigation Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        // Navigate to settings
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.home),
                      onPressed: () {
                        // Navigate to home
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        // Navigate to profile
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}