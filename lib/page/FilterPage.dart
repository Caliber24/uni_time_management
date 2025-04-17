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
      'day': 'روز برگزاری',
      'course_name': 'عنوان درس',
      'time': 'ساعت برگزاری',
      'status': 'وضعیت',
      'exam_date': 'تاریخ امتحان',
      'department_code': 'کد رشته',
      'university_name': 'نام دانشگاه',
      'professor_id': 'کد استاد',
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
                        children:
                            columnLabels.entries.map((entry) {
                              return FilterChip(
                                checkmarkColor: Colors.lightGreen,
                                selectedColor: Color(0xff1a2b8a),
                                disabledColor: Colors.grey,
                                label: Text(
                                  entry.value,
                                  style: TextStyle(
                                    color:
                                        _selectedColumns.contains(entry.key)
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
                        child: DropdownButtonFormField<String>(

                          decoration: InputDecoration(

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ), // تنظیم فاصله داخلی
                          ),
                          value: _selectedStatus,
                          icon: const Icon(
                            Icons.arrow_drop_down, // آیکون فلش
                            color: Colors.black,

                          ),

                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          dropdownColor: Colors.white,
                          itemHeight: 50,
                          items:
                              [
                                'همه کلاس‌ها',
                                'فقط در حال برگزاری‌ها',
                                'کلاس‌های لغو شده',
                              ].map((status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    // فاصله از سمت راست
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      // تراز آیتم‌ها به سمت راست (در RTL به چپ تبدیل می‌شود)
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              status == 'کلاس‌های لغو شده'
                                                  ? Colors.red
                                                  : Colors.black,
                                        ),
                                      ),
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
}
