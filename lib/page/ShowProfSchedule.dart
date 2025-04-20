import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uni_time_management/page/FilterPageProf.dart';

class ShowProfSchedule extends StatefulWidget {
  final String selectedSemester;
  final int universityId;
  final String universityName;
  final List<dynamic> filteredSchedules;

  const ShowProfSchedule({
    Key? key,
    required this.universityId,
    required this.universityName,
    required this.selectedSemester,
    required this.filteredSchedules,
  }) : super(key: key);

  @override
  _ShowProfScheduleState createState() => _ShowProfScheduleState();
}

class _ShowProfScheduleState extends State<ShowProfSchedule> {
  List<String> selectedDays = [];
  List<dynamic> facultySchedule = [];
  ScrollController _horizontalScrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _useResponsiveLayout = true;

  // مدیریت فیلترهای ستونی و وضعیت
  List<String> selectedColumns = [
    'day_name',
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
    'پنج‌شبه': 5, // اصلاح املایی برای هماهنگی با JSON
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      facultySchedule = widget.filteredSchedules;
    });
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
    List<Map<String, dynamic>> formatSchedule = facultySchedule
        .map<Map<String, dynamic>>((schedule) => {
      'day_name': schedule['day_name'] ?? 'تعیین نشده',
      'course_name': schedule['course_name'] ?? 'تعیین نشده',
      'professor_name': schedule['professor_name'] ?? 'تعیین نشده',
      'time':
      '${schedule['start_time'] ?? 'تعیین نشده'}-${schedule['end_time'] ?? 'تعیین نشده'}',
      'status': schedule['status'] ?? 'تعیین نشده',
      'exam_date': schedule['exam_date'] ?? 'تعیین نشده',
      'department_code': schedule['department_code'] ?? 'تعیین نشده',
      'university_name':
      schedule['university_name'] ?? 'تعیین نشده', // مدیریت اشتباه تایپی
      'professor_id': schedule['professor_id' ] ?? 'تعیین نشده',
      'semester': schedule['semester'] ?? 'تعیین نشده',
    })
        .toList();

    // اعمال فیلتر روزهای انتخاب‌شده
    if (selectedDays.isNotEmpty) {
      formatSchedule = formatSchedule
          .where((schedule) => selectedDays.contains(schedule['day_name']))
          .toList();
    }

    // اعمال فیلتر جستجو
    if (_searchQuery.isNotEmpty) {
      formatSchedule = formatSchedule
          .where((schedule) => schedule['professor_name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // اعمال فیلتر وضعیت
    if (selectedStatus != 'همه کلاس‌ها') {
      formatSchedule = formatSchedule
          .where((schedule) =>
      schedule['status'] ==
          (selectedStatus == 'فقط در حال برگزاری‌ها' ? 'برگزار' : 'لغو'))
          .toList();
    }

    // مرتب‌سازی بر اساس روز و زمان
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

  void _toggleLayout() {
    setState(() {
      _useResponsiveLayout = !_useResponsiveLayout;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredSchedule = filterSchedule();
    return Scaffold(
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
                        _buildDayButton('پنج‌شنبه'),
                      ],
                    ),
                    SizedBox(height: 20),
                    TableScheduleWidget(
                      filteredSchedule: filteredSchedule,
                      selectedColumns: selectedColumns,
                      horizontalScrollController: _horizontalScrollController,
                    ),
                    SizedBox(height: 80),
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
            suffixIcon: searchQuery.isNotEmpty
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
    required this.horizontalScrollController,
  }) : super(key: key);

  final List<Map<String, dynamic>> filteredSchedule;
  final List<String> selectedColumns;
  final ScrollController horizontalScrollController;

  @override
  Widget build(BuildContext context) {
    // تعریف ستون‌های ممکن و نگاشت آن‌ها به نام‌های نمایشی
    final Map<String, String> columnLabels = {
      'day_name': 'روز',
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
    final List<DataColumn> columns = selectedColumns
        .where((col) => columnLabels.containsKey(col))
        .map(
          (col) => DataColumn(
        label: Text(columnLabels[col]!),
      ),
    )
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: filteredSchedule.isEmpty
          ? Center(child: Text('هیچ برنامه‌ای یافت نشد'))
          : SingleChildScrollView(
        controller: horizontalScrollController,
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: DataTable(
            headingRowColor: MaterialStatePropertyAll(Color(0xFF636DC5)),
            dataRowMaxHeight: 50,
            columnSpacing: 16,
            dataRowMinHeight: 30,
            border: TableBorder.all(color: Color(0xFF878FD6)),
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