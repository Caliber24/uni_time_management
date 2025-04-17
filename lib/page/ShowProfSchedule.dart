import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_time_management/page/FilterPage.dart';

class ShowProfSchedule extends StatefulWidget {
  @override
  _ShowProfSchedule createState() => _ShowProfSchedule();
}

class _ShowProfSchedule extends State<ShowProfSchedule> {
  String? selectedSemester; // ترم انتخاب‌شده، null به معنی "همه ترم‌ها"
  List<String> availableSemesters = []; // لیست ترم‌های موجود
  List<String> selectedDays = [];
  List<dynamic> facultySchedule = [];
  ScrollController _horizontalScrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _useResponsiveLayout = true;

  // مدیریت فیلترهای ستونی و وضعیت
  List<String> selectedColumns = [
    'day',
    'course_name',
    'professor_name',
    'time',
    'status',
    'exam_date',
    'department_code',
    'university_name',
    'professor_id',
  ]; // ستون‌های پیش‌فرض
  String selectedStatus = 'همه کلاس‌ها'; // وضعیت پیش‌فرض

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

      availableSemesters =
          facultySchedule
              .map((schedule) => schedule['semester'] as String)
              .toSet()
              .toList()
            ..sort();
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

  void _openFilterPage() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: FilterPage(
                selectedColumns: selectedColumns,
                selectedStatus: selectedStatus,
                onApplyFilters: (newColumns, newStatus) {
                  setState(() {
                    selectedColumns = newColumns;
                    selectedStatus = newStatus;
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> filterSchedule() {
    List<Map<String, dynamic>> formatSchedule =
        facultySchedule
            .map<Map<String, dynamic>>(
              (schedule) => {
                'day': schedule['day'] ?? 'تعیین نشده',
                'course_name': schedule['course_name'] ?? 'تعیین نشده',
                'professor_name': schedule['professor_name'] ?? 'تعیین نشده',
                'time': schedule['time'] ?? 'تعیین نشده',
                'status': schedule['status'] ?? 'تعیین نشده',
                'exam_date': schedule['exam_date'] ?? 'تعیین نشده',
                'department_code': schedule['department_code'] ?? 'تعیین نشده',
                'university_name': schedule['university_name'] ?? 'تعیین نشده',
                'professor_id': schedule['professor_id'] ?? 'تعیین نشده',
                'semester': schedule['semester'] ?? 'تعیین نشده',
              },
            )
            .toList();

    // اعمال فیلتر روزهای انتخاب‌شده
    if (selectedDays.isNotEmpty) {
      formatSchedule =
          formatSchedule
              .where((schedule) => selectedDays.contains(schedule['day']))
              .toList();
    }

    if (selectedSemester != null) {
      formatSchedule =
          formatSchedule
              .where((schedule) => schedule['semester'] == selectedSemester)
              .toList();
    }

    // اعمال فیلتر جستجو
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

    // اعمال فیلتر وضعیت
    if (selectedStatus != 'همه کلاس‌ها') {
      formatSchedule =
          formatSchedule
              .where(
                (schedule) =>
                    schedule['status'] ==
                    (selectedStatus == 'فقط در حال برگزاری‌ها'
                        ? 'برگزار'
                        : 'لغو'),
              )
              .toList();
    }

    // مرتب‌سازی بر اساس روز و زمان
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
    final filteredSchedule = filterSchedule();
    return Scaffold(
      body:
          facultySchedule.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Row(
                            children: [
                              BackButtonWidget(),
                              SizedBox(width: 12),
                              SearchWidget(
                                searchQuery: _searchQuery,
                                controller: _searchController,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            direction: Axis.horizontal,
                            textDirection: TextDirection.rtl,
                            alignment: WrapAlignment.start,
                            children: [
                              _buildDayButton('شنبه'),
                              _buildDayButton('یکشنبه'),
                              _buildDayButton('دوشنبه'),
                              _buildDayButton('سه‌شنبه'),
                              _buildDayButton('چهارشنبه'),
                            ],
                          ),
                          SizedBox(height: 20),
                          buildSemesterSelector(),
                          SizedBox(height: 20),
                          TableScheduleWidget(
                            filteredSchedule: filteredSchedule,
                            selectedColumns: selectedColumns,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 25,
                    bottom: 20,
                    child: Material(
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        onTap: _openFilterPage,
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(0xFF00137B),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.filter_alt_sharp,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavButton(Icons.settings_input_component, 'تعیین نشده'),
            buildNavButton(Icons.home, 'تعیین نشده'),
            buildNavButton(Icons.person_outline, 'تعیین نشده'),
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

  Widget buildSemesterSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Directionality(
        textDirection: TextDirection.rtl, // اعمال RTL برای کل ویجت
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF1A2B8A), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSemester,
                // مقدار انتخاب‌شده
                hint: Padding(
                  padding: const EdgeInsets.only(right: 12.0), // فاصله از راست
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // تراز به راست
                    children: [
                      Text(
                        'انتخاب ترم',
                        textAlign: TextAlign.right, // اطمینان از راست‌چین بودن
                        style: TextStyle(
                          color: Color(0xFF1A2B8A),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.calendar_today,
                        color: Color(0xFF1A2B8A),
                        size: 20,
                      ),
                    ],
                  ),
                ),
                isExpanded: true,
                icon: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF1A2B8A),
                    size: 28,
                  ),
                ),
                style: TextStyle(
                  color: Color(0xFF1A2B8A),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 4,
                items: [
                  // آیتم "همه ترم‌ها" با مقدار null
                  DropdownMenuItem<String>(
                    value: null,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      // فاصله از راست
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start, // تراز به راست
                          children: [
                            Text(
                              'همه ترم‌ها',
                              textAlign: TextAlign.right,
                              // اطمینان از راست‌چین بودن
                              style: TextStyle(
                                color: Color(0xFF1A2B8A),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // سایر ترم‌ها
                  ...availableSemesters.map((semester) {
                    return DropdownMenuItem<String>(
                      value: semester,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        // فاصله از راست
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // تراز به راست
                          children: [
                            Text(
                              semester,
                              textAlign: TextAlign.right,
                              // اطمینان از راست‌چین بودن
                              style: TextStyle(
                                color: Color(0xFF1A2B8A),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedSemester = value; // به‌روزرسانی مقدار انتخاب‌شده
                    print('Selected semester: $selectedSemester'); // برای دیباگ
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavButton(IconData icon, String label) {
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
  const TableScheduleWidget({
    Key? key,
    required this.filteredSchedule,
    required this.selectedColumns,
  }) : super(key: key);

  final List<Map<String, dynamic>> filteredSchedule;
  final List<String> selectedColumns;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // تعریف ستون‌های ممکن و نگاشت آن‌ها به نام‌های نمایشی
    final Map<String, String> columnLabels = {
      'day': 'روز',
      'course_name': 'عنوان درس',
      'professor_name': 'نام استاد',
      'time': 'ساعت برگزاری',
      'status': 'وضعیت',
      'exam_date': 'تاریخ امتحان',
      'department_code': 'کد رشته',
      'university_name': 'نام دانشگاه',
      'professor_id': 'کد استاد',
    };

    // فیلتر کردن ستون‌های انتخاب‌شده
    final List<DataColumn> columns =
        selectedColumns
            .where((col) => columnLabels.containsKey(col))
            .map(
              (col) => DataColumn(
                label: Text(columnLabels[col]!),
                columnWidth: FixedColumnWidth(100),
              ),
            )
            .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: DataTable(
            headingRowColor: MaterialStatePropertyAll(Color(0xFF636DC5)),
            dataRowMaxHeight: 50,
            columnSpacing: 16,
            dataRowMinHeight: 30,
            border: TableBorder.all(color: Color(0xFF878FD6)),
            columns: columns,
            rows:
                filteredSchedule.map((schedule) {
                  return DataRow(
                    cells:
                        selectedColumns
                            .where((col) => columnLabels.containsKey(col))
                            .map(
                              (col) => DataCell(
                                Tooltip(
                                  message: schedule[col],
                                  child: Text(
                                    schedule[col] ?? 'تعیین نشده',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
