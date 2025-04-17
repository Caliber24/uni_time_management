import 'package:flutter/material.dart';

class DailyScheduleView extends StatefulWidget {
  const DailyScheduleView({Key? key}) : super(key: key);

  @override
  _DailyScheduleViewState createState() => _DailyScheduleViewState();
}

class _DailyScheduleViewState extends State<DailyScheduleView> {
  final TextEditingController _searchController = TextEditingController();
  String currentDate = '۱۴ اسفند ۱۴۰۳'; // Persian date

  // Sample data for the schedule table
  final List<Map<String, dynamic>> scheduleData = [
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۲',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۱',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۲',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۲',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'لغو',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۱',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۲',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۱',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۱',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'لغو',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۱',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۲',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۱',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۱',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'لغو',
    },
    {
      'group': 'کامپیوتر',
      'code': '۳۲۱۶',
      'title': 'مهندسی نرم افزار ۱',
      'time': '۸:۰۰ - ۱۰:۰۰',
      'status': 'برگزار',
    },
  ];

  void _previousDay() {
    // Logic to go to previous day
    setState(() {
      // This is just a placeholder. In a real app, you would calculate the previous day
      currentDate = '۱۳ اسفند ۱۴۰۳';
    });
  }

  void _nextDay() {
    // Logic to go to next day
    setState(() {
      // This is just a placeholder. In a real app, you would calculate the next day
      currentDate = '۱۵ اسفند ۱۴۰۳';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              // Top navigation and search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Back button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF001F6B),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Search bar
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: const Color(0xFF001F6B)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'چیزی برای جستجو وارد کنید',
                            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Date navigation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous day button
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 18),
                        onPressed: _previousDay,
                      ),

                      // Current date
                      Text(
                        currentDate,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Next day button
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                        onPressed: _nextDay,
                      ),
                    ],
                  ),
                ),
              ),

              // Table header
              Container(
                color: const Color(0xFFB8C4E8), // Light blue background
                child: Table(
                  border: TableBorder.all(color: Colors.blue[100]!),
                  columnWidths: const {
                    0: FlexColumnWidth(1.2), // Group
                    1: FlexColumnWidth(1), // Code
                    2: FlexColumnWidth(2), // Title
                    3: FlexColumnWidth(1.5), // Time
                    4: FlexColumnWidth(1), // Status
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8C4E8),
                      ),
                      children: [
                        _buildTableHeader('گروه'),
                        _buildTableHeader('کد درس'),
                        _buildTableHeader('عنوان درس'),
                        _buildTableHeader('ساعت برگزاری'),
                        _buildTableHeader('وضعیت'),
                      ],
                    ),
                  ],
                ),
              ),

              // Table content
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.blue[100]!),
                    columnWidths: const {
                      0: FlexColumnWidth(1.2), // Group
                      1: FlexColumnWidth(1), // Code
                      2: FlexColumnWidth(2), // Title
                      3: FlexColumnWidth(1.5), // Time
                      4: FlexColumnWidth(1), // Status
                    },
                    children: scheduleData.map((item) {
                      return TableRow(
                        children: [
                          _buildTableCell(item['group']),
                          _buildTableCell(item['code']),
                          _buildTableCell(item['title']),
                          _buildTableCell(item['time']),
                          _buildTableCell(
                            item['status'],
                            textColor: item['status'] == 'لغو' ? Colors.red : Colors.black,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Bottom navigation bar
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
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
                ),
              ),
            ],
          ),
        ),
      ),
      // Filter button (floating action button)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF001F6B),
        onPressed: () {
          // Show filter options
        },
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}