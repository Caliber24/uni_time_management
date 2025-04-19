import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final List<String> selectedColumns;
  final String selectedStatus;
  final Function(List<String>, String) onApplyFilters;

  FilterPage({
    required this.selectedColumns,
    required this.selectedStatus,
    required this.onApplyFilters,
  });

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late List<String> _selectedColumns;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedColumns = List.from(widget.selectedColumns);
    _selectedStatus = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> columnLabels = {
      'day_name': 'روز برگزاری',
      'time': 'ساعت برگزاری',
      'status': 'وضعیت',
      'exam_date': 'تاریخ امتحان',
      'department_code': 'کد رشته',
      'university_name': 'نام دانشگاه',
      'professor_id': 'کد استاد',
      'course_name': 'نام درس',
      'professor_name': 'نام استاد',
    };

    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              const Text(
                'فیلتر کردن نتایج',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            children: [
                              Icon(Icons.filter_list),
                              SizedBox(width: 5),
                              Text(
                                'فیلتر ستونی',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1a2b8a),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.end,
                        children: columnLabels.entries.map((entry) {
                          return FilterChip(
                            checkmarkColor: Colors.lightGreen,
                            selectedColor: Color(0xff1a2b8a),
                            disabledColor: Colors.grey,
                            label: Text(
                              entry.value,
                              style: TextStyle(
                                color: _selectedColumns.contains(entry.key)
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            selected: _selectedColumns.contains(entry.key),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedColumns.add(entry.key);
                                } else {
                                  _selectedColumns.remove(entry.key);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            Icon(Icons.filter_list),
                            SizedBox(width: 5),
                            Text(
                              'فیلتر سطری',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1a2b8a),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: _buildStatusSelector(),
                      ),
                      const SizedBox(height: 20),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: SizedBox(
                          height: 50,
                          width: 180,
                          child: ElevatedButton(
                            clipBehavior: Clip.antiAlias,
                            onPressed: () {
                              widget.onApplyFilters(
                                _selectedColumns,
                                _selectedStatus,
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1a2b8a),
                              minimumSize: const Size(200, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'فیلتر کردن',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 25,
          bottom: 80,
          child: Material(
            borderRadius: BorderRadius.circular(100),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF00137B),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 6)),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF1A2B8A), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF1A2B8A), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF00137B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          prefixIcon: Icon(
            Icons.filter_list,
            color: Color(0xFF1A2B8A),
            size: 20,
          ),
        ),
        value: _selectedStatus,
        icon: Icon(Icons.arrow_drop_down, color: Color(0xFF1A2B8A), size: 28),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A2B8A),
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 4,
        itemHeight: 50,
        items: ['همه کلاس‌ها', 'فقط در حال برگزاری‌ها', 'کلاس‌های لغو شده'].map((status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: status == 'کلاس‌های لغو شده'
                          ? Colors.redAccent
                          : status == 'فقط در حال برگزاری‌ها'
                          ? Colors.green
                          : Color(0xFF1A2B8A),
                    ),
                  ),
                  if (status == 'کلاس‌های لغو شده') ...[
                    SizedBox(width: 8),
                    Icon(Icons.cancel, color: Colors.redAccent, size: 18),
                  ],
                  if (status == 'فقط در حال برگزاری‌ها') ...[
                    SizedBox(width: 8),
                    Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedStatus = value!;
          });
        },
      ),
    );
  }
}