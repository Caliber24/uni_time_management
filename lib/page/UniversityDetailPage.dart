import 'package:flutter/material.dart';
import 'package:uni_time_management/model/univercity_model.dart';
import 'package:uni_time_management/global.dart' as globals;
import 'ProfessorSchedulePage.dart'; // وارد کردن صفحه جدید

class UniversityDetailPage extends StatefulWidget {
  final University university;

  const UniversityDetailPage({Key? key, required this.university}) : super(key: key);

  @override
  State<UniversityDetailPage> createState() => _UniversityDetailPageState();
}

class _UniversityDetailPageState extends State<UniversityDetailPage> {
  final List<String> termOptions = ["1404-1", "1404-2"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        "assets${widget.university.image}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.university.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  /// 🔽 Dropdown for selecting term with improved style
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF031A6B), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: globals.selectedTerm,
                        items: termOptions.map((term) {
                          return DropdownMenuItem<String>(
                            value: term,
                            child: Text(
                              term,
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            globals.selectedTerm = value!;
                          });
                        },
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF031A6B)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildMenuItem(Icons.calendar_view_week, "برنامه هفتگی"),
                        _buildMenuItem(Icons.today, "برنامه روزانه"),
                        _buildMenuItem(Icons.fact_check, "برنامه امتحانی"),
                        _buildMenuItem(
                          Icons.people_outline,
                          "برنامه کلاسی استاد",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfessorSchedulePage(
                                  universityId: widget.university.id,
                                  universityName: widget.university.name,
                                  selectedTerm: globals.selectedTerm,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(Icons.schedule, "برنامه کلی"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Color(0xFF031A6B)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF031A6B),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        onTap: (index) {
          if (index == 1) {
            Navigator.pop(context);
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
      ),
    );
  }
}
