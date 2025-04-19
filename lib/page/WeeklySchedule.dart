import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uni_time_management/page/WeeklyFilterPage.dart';

class WeeklyScheduleView extends StatefulWidget {
  final List<dynamic> filteredSchedules;

  const WeeklyScheduleView({Key? key, required this.filteredSchedules})
      : super(key: key);

  @override
  _WeeklyScheduleViewState createState() => _WeeklyScheduleViewState();
}

class _WeeklyScheduleViewState extends State<WeeklyScheduleView> {
  List<String> selectedDays = [];
  ScrollController _horizontalScrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // مدیریت فیلترهای ستونی و وضعیت
  List<String> selectedColumns = [
    'day_name',
    'course_name',
    'professor_name',
    'time',
    'course_status',
    'exam_date',
    'department_name',
    'classroom',
    'semester',
  ];

  final Map<String, String> columnLabels = {
    'day_name': 'روز',
    'course_name': 'عنوان درس',
    'professor_name': 'نام استاد',
    'time': 'ساعت برگزاری',
    'course_status': 'وضعیت',
    'exam_date': 'تاریخ امتحان',
    'department_name': 'نام دپارتمان',
    'classroom': 'محل کلاس',
    'semester': 'ترم',
  };
  String selectedStatus = 'همه کلاس‌ها';

  final Map<String, int> _dayOrder = {
    'شنبه': 0,
    'یکشنبه': 1,
    'دوشنبه': 2,
    'سه‌شنبه': 3,
    'چهارشنبه': 4,
    'پنج‌شنبه': 5,
  };

  @override
  void initState() {
    super.initState();
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
              child: WeeklyFilterPage(
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
    List<Map<String, dynamic>> formatSchedule = widget.filteredSchedules
        .map<Map<String, dynamic>>((schedule) => {
      'day_name': schedule['day_name'] ?? 'تعیین نشده',
      'course_name': schedule['course_name'] ?? 'تعیین نشده',
      'professor_name': schedule['professor_name'] ?? 'تعیین نشده',
      'time':
      '${schedule['start_time'] ?? 'تعیین نشده'}-${schedule['end_time'] ?? 'تعیین نشده'}',
      'course_status': schedule['course_status'] ?? 'تعیین نشده',
      'exam_date': schedule['exam_date'] ?? 'تعیین نشده',
      'department_name': schedule['department_name'] ?? 'تعیین نشده',
      'classroom': schedule['classroom'] ?? 'تعیین نشده',
      'semester': schedule['semester'] ?? 'تعیین نشده',
    })
        .toList();

    if (selectedDays.isNotEmpty) {
      formatSchedule = formatSchedule
          .where((schedule) => selectedDays.contains(schedule['day_name']))
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      formatSchedule = formatSchedule
          .where((schedule) =>
      schedule['course_name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          schedule['professor_name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (selectedStatus != 'همه کلاس‌ها') {
      formatSchedule = formatSchedule
          .where((schedule) =>
      schedule['course_status'] ==
          (selectedStatus == 'فقط در حال برگزاری‌ها' ? 'برگزار' : 'لغو'))
          .toList();
    }

    formatSchedule.sort((a, b) {
      int dayOrderA = _dayOrder[a['day_name']] ?? 6;
      int dayOrderB = _dayOrder[b['day_name']] ?? 6;

      if (dayOrderA == dayOrderB) {
        return (a['time'] ?? 'تعیین نشده')
            .compareTo(b['time'] ?? 'تعیین نشده');
      }
      return dayOrderA.compareTo(dayOrderB);
    });

    return formatSchedule;
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
        backgroundColor: isSelected ? const Color(0xff1a2b8a) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        side: const BorderSide(color: Color(0xff1a2b8a), width: 1),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xff1a2b8a),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSchedule = filterSchedule();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00137B),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF1A2B8A),
                                width: 1.5,
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                hintText: 'نام درس یا استاد را جستجو کنید',
                                hintStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFFCCCCCC),
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
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
                        _buildDayButton('پنج‌شنبه'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TableScheduleWidget(
                      filteredSchedule: filteredSchedule,
                      selectedColumns: selectedColumns,
                      horizontalScrollController: _horizontalScrollController,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 25,
              bottom: 20,
              child: Material(
                borderRadius: BorderRadius.circular(100),
                elevation: 4,
                child: InkWell(
                  onTap: _openFilterPage,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00137B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
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
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavButton(Icons.settings_input_component, 'تنظیمات'),
            buildNavButton(Icons.home, 'خانه'),
            buildNavButton(Icons.person_outline, 'پروفایل'),
          ],
        ),
      ),
    );
  }

  Widget buildNavButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class TableScheduleWidget extends StatelessWidget {
  final List<Map<String, dynamic>> filteredSchedule;
  final List<String> selectedColumns;
  final ScrollController horizontalScrollController;

  const TableScheduleWidget({
    Key? key,
    required this.filteredSchedule,
    required this.selectedColumns,
    required this.horizontalScrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> columnLabels = {
      'day_name': 'روز',
      'course_name': 'عنوان درس',
      'professor_name': 'نام استاد',
      'time': 'ساعت برگزاری',
      'course_status': 'وضعیت',
      'exam_date': 'تاریخ امتحان',
      'department_name': 'نام دپارتمان',
      'classroom': 'محل کلاس',
      'semester': 'ترم',
    };

    final List<DataColumn> columns = selectedColumns
        .where((col) => columnLabels.containsKey(col))
        .map((col) => DataColumn(label: Text(columnLabels[col]!)))
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: filteredSchedule.isEmpty
          ? const Center(child: Text('هیچ برنامه‌ای یافت نشد'))
          : SingleChildScrollView(
        controller: horizontalScrollController,
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Color(0xFF636DC5)),
            dataRowMaxHeight: 50,
            columnSpacing: 16,
            dataRowMinHeight: 30,
            border: TableBorder.all(color: const Color(0xFF878FD6)),
            columns: columns,
            rows: filteredSchedule.map((schedule) {
              return DataRow(
                cells: selectedColumns
                    .where((col) => columnLabels.containsKey(col))
                    .map(
                      (col) => DataCell(
                    Tooltip(
                      message: schedule[col] ?? 'تعیین نشده',
                      child: Text(
                        schedule[col] ?? 'تعیین نشده',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: col == 'course_status' &&
                              schedule[col] == 'لغو'
                              ? Colors.red
                              : Colors.black,
                        ),
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