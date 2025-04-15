import 'package:flutter/material.dart';

class ResponsiveScheduleWidget extends StatelessWidget {
  const ResponsiveScheduleWidget({
    Key? key,
    required this.filteredSchedule,
  }) : super(key: key);

  final List<Map<String, dynamic>> filteredSchedule;

  @override
  Widget build(BuildContext context) {
    return filteredSchedule.isEmpty
        ? Center(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          'هیچ نتیجه‌ای یافت نشد!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    )
        : Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
        itemCount: filteredSchedule.length,
        itemBuilder: (context, index) {
          final schedule = filteredSchedule[index];
          final bool isCancelled = schedule['status'] == 'لغو';

          // Group header for day change
          bool showDayHeader = index == 0 ||
              schedule['day'] != filteredSchedule[index - 1]['day'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDayHeader)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Text(
                    schedule['day'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2B8A),
                    ),
                  ),
                ),
              Card(
                margin: EdgeInsets.only(bottom: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Color(0xFFA7B0F8),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              schedule['professor_name'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isCancelled ? Colors.red.shade50 : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCancelled ? Colors.red : Colors.green,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              schedule['status'] ?? '',
                              style: TextStyle(
                                color: isCancelled ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            schedule['time'] ?? '',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.book, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'کد درس: ${schedule['course_code'] ?? ''}',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
