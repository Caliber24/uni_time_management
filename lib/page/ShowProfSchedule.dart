import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowProfSchedule extends StatefulWidget {
  @override
  _ShowProfSchedule createState() => _ShowProfSchedule();
}

class _ShowProfSchedule extends State<ShowProfSchedule> {
  List<String> selectedDays = [];
  List<dynamic> facultySchedule = [];
  ScrollController _horizontalScrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _useResponsiveLayout =
      true; // Toggle between table and responsive layout

  final Map<String, int> _dayOrder = {
    'شنبه': 0,
    'یکشنبه': 1,
    'دوشنبه': 2,
    'سه‌شنبه': 3,
    'چهارشنبه': 4,
  };

  Future<void> loadData() async {
    final String response = await rootBundle.loadString(
      "assets/api/professors.json",
    );
    final data = await json.decode(response);
    setState(() {
      facultySchedule = data['faculty_schedule'];

    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<Map<String, dynamic>> filterScheduleBySelectedDays() {
    List<Map<String, dynamic>> formatSchedule =
        facultySchedule
            .map<Map<String, dynamic>>(
              (schedule) => {
                'course_code': schedule['course_code'] ?? '٣١٤٦',
                'time': schedule['time'] ?? '٨:٠٠ - ١٠:٠٠',
                'professor_name':
                    schedule['professor_name'] ?? 'دکتر ابراهیم صحافی',
                'day': schedule['day'] ?? 'شنبه',
                'status': schedule['status'] ?? 'برگزار',
              },
            )
            .toList();
    if (selectedDays.isNotEmpty) {
      formatSchedule =
          formatSchedule
              .where((schedule) => selectedDays.contains(schedule['day']))
              .toList();
    }

    if (_searchQuery.isNotEmpty) {
      formatSchedule =
          formatSchedule
              .where(
                (schedule) => schedule['professor_name'].toString().contains(
                  _searchQuery,
                ),
              )
              .toList();
    }

    formatSchedule.sort((a, b) {
      int dayOrderA = _dayOrder[a['day']] ?? 5;
      int dayOrderB = _dayOrder[b['day']] ?? 5;

      if (dayOrderA == dayOrderB) {
        return (a['time'] ?? 'تعیین نشده').compareTo(b['time'] ?? 'تعیین نشده');
      }
      return dayOrderA.compareTo(dayOrderB);
    });

    return formatSchedule;
  }

  void _toggleLayout() {
    setState(() {
      _useResponsiveLayout = !_useResponsiveLayout;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredSchedule = filterScheduleBySelectedDays();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            facultySchedule.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // Row containing back button and search field
                      Row(
                        children: [
                          // Back button
                          BackButtonWidget(),
                          SizedBox(
                            width: 12,
                          ), // Space between button and search field
                          // Search field
                          SearchWidget(
                            searchQuery: _searchQuery,
                            controller: _searchController,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // بخش انتخاب روز ها
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        direction: Axis.horizontal,
                        textDirection: TextDirection.rtl,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildDayButton('شنبه'),
                          _buildDayButton('یکشنبه'),
                          _buildDayButton('دوشنبه'),
                          _buildDayButton('سه‌شنبه'),
                          _buildDayButton('چهارشنبه'),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Search results count
                      // if (_searchQuery.isNotEmpty)
                      //   Padding(
                      //     padding: const EdgeInsets.only(bottom: 8.0),
                      //     child: Directionality(
                      //       textDirection: TextDirection.rtl,
                      //       child: Text(
                      //         'نتایج جستجو برای "${_searchQuery}": ${filteredSchedule.length} مورد',
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      TableScheduleWidget(filteredSchedule: filteredSchedule),
                    ],
                  ),
                ),
      ),
      bottomNavigationBar: // Bottom navigation
          Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavButton(Icons.settings_input_component, 'تعیین نشده'),
            _buildNavButton(Icons.home, 'تعیین نشده'),
            _buildNavButton(Icons.person_outline, 'تعیین نشده'),
          ],
        ),
      ),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xff1a2b8a) : Colors.white,
        minimumSize: Size(80, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        side: BorderSide(color: Color(0xff1a2b8a), width: 1),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : Color(0xff1a2b8a),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        if (label.isNotEmpty) Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFF00137B), // Deep blue color
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
        padding: EdgeInsets.zero,
        onPressed: () {
          // Add your back button functionality here
          Navigator.pop(context);
        },
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.searchQuery,
    required this.controller,
  });

  final String searchQuery;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF1A2B8A), width: 1.5),
        ),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'نام استاد را مورد نظر را وارد کنید',
            hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Color(0xFFCCCCCC)),
            suffixIcon:
                searchQuery.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                      },
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class TableScheduleWidget extends StatelessWidget {
  const TableScheduleWidget({Key? key, required this.filteredSchedule})
    : super(key: key);

  final List<Map<String, dynamic>> filteredSchedule;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(

          child: DataTable(
            headingRowColor: MaterialStatePropertyAll(Color(0xFF2E3BAB)),
            dataRowMaxHeight: 50,
            columnSpacing: 8,

            dataRowMinHeight: 30,
            border: TableBorder.all(color: Color(0xFF6B74C0)),
            columns: [
              DataColumn(label: Text('روز',),),
              DataColumn(label: Text('کد درس')),
              DataColumn(label: Text('نام استاد')),
              DataColumn(label: Text('ساعت برگزاری')),
              DataColumn(label: Text('وضعیت')),
            ],
            rows: [
              ...filteredSchedule.map((schedule) {
                return DataRow(
                  cells: [
                    DataCell(Text(schedule['day'] ?? 'تعیین نشده')),
                    DataCell(Text(schedule['course_code'] ?? 'تعیین نشده')),
                    DataCell(Text(schedule['professor_name'] ?? 'تعیین نشده')),
                    DataCell(Text(schedule['time'] ?? 'تعیین نشده')),
                    DataCell(Text(schedule['status'] ?? 'برگزار')),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child:
//           filteredSchedule.isEmpty
//               ? Center(
//                 child: Text(
//                   'هیچ نتیجه‌ای یافت نشد!',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               )
//               : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildRow(
//                     isHeader: true,
//                     data: {
//                       'day': 'روز',
//                       'course_code': 'کد درس',
//                       'professor_name': 'نام استاد',
//                       'time': 'ساعت برگزاری',
//                       'status': 'وضعیت',
//                     },
//                   ),
//                   ...filteredSchedule.map((schedule) {
//                     return _buildRow(data: schedule);
//                   }).toList(),
//                 ],
//               ),
//     );
//   }
//
//   Widget _buildRow({
//     required Map<String, dynamic> data,
//     bool isHeader = false,
//   }) {
//     final TextStyle headerStyle = TextStyle(
//       fontWeight: FontWeight.bold,
//       color: Colors.white,
//       fontSize: 14,
//     );
//
//     final TextStyle cellStyle = TextStyle(
//       fontSize: 14,
//       fontWeight: FontWeight.w400,
//       color: Colors.black,
//     );
//
//     final bool isCancelled = data['status'] == 'لغو';
//
//     return Container(
//       color: isHeader ? Color(0xFF535DB0) : Colors.transparent,
//       child: Row(
//         children: [
//           _buildCell(data['day'] ?? 'تعیین نشده', 80, isHeader ? headerStyle : cellStyle),
//           _buildCell(
//             data['course_code'] ?? 'تعیین نشده',
//             80,
//             isHeader ? headerStyle : cellStyle,
//           ),
//           _buildCell(
//             data['professor_name'] ?? 'تعیین نشده',
//             140,
//             isHeader ? headerStyle : cellStyle,
//           ),
//           _buildCell(
//             data['time'] ?? 'تعیین نشده',
//             100,
//             isHeader ? headerStyle : cellStyle,
//           ),
//           _buildCell(
//             data['status'] ?? 'تعیین نشده',
//             80,
//             isHeader
//                 ? headerStyle
//                 : cellStyle.copyWith(
//                   color: isCancelled ? Colors.red : Colors.black,
//                   fontWeight: isCancelled ? FontWeight.bold : FontWeight.w400,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCell(String text, double width, TextStyle style) {
//     return Container(
//       width: width,
//       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       decoration: BoxDecoration(
//         border: Border(
//           right: BorderSide(color: Color(0xFFA7B0F8)),
//           bottom: BorderSide(color: Color(0xFFA7B0F8)),
//         ),
//       ),
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         overflow: TextOverflow.ellipsis,
//         style: style,
//       ),
//     );
//   }
// }
