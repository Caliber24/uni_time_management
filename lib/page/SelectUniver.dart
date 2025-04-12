import 'dart:convert';
import 'package:uni_time_management/model/univercity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UniversityPage extends StatefulWidget {
  @override
  State<UniversityPage> createState() => _UniversityPageState();
}

class _UniversityPageState extends State<UniversityPage> {
  List<University> _universities = [];
  List<University> filtered = [];

  @override
  void initState() {
    super.initState();
    loadUniversityData();
  }

  Future<void> loadUniversityData() async {
    final String jsonString =
    await rootBundle.loadString('assets/api/university.json');
    print("Trying to load JSON");
    print(jsonString);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> jsonList = jsonMap['universities'];

    setState(() {
      _universities =
          jsonList.map((item) => University.fromJson(item)).toList();
      filtered = _universities;
    });
  }

  void _filter(String query) {
    setState(() {
      filtered = _universities
          .where((u) => u.name.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
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
              offset: const Offset(0, -3), // سایه از بالا
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 1,

          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.transparent, // چون رنگ تو Container هست
          elevation: 0, // از خود BottomNavigationBar نمی‌خوایم سایه بخوره
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
            items: const [
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 18),
                    Icon(Icons.settings),
                  ],
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 18),
                    Icon(Icons.home),
                  ],
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 18),
                    Icon(Icons.person),
                  ],
                ),
                label: "",
              ),
            ],
        ),
      ),



      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // جستجو و فلش
          Row(
          children: [
          Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              onChanged: _filter,
              textDirection: TextDirection.rtl, //

              decoration: InputDecoration(
                hintTextDirection: TextDirection.rtl,
                hintText: "چیزی برای جستجو وارد کنید",
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.indigo),
              ),
            ),
          ),
        ),
        ],
      ),

              const SizedBox(height: 20),
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "لطفا یک دانشگاه انتخاب کنید.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),

              const SizedBox(height: 10),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl, // آیتم‌ها از راست شروع می‌شوند
                  child: GridView.builder(
                    itemCount: filtered.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final university = filtered[index];

                      return MouseRegion(
                        onEnter: (_) {},
                        onExit: (_) {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets${university.image}",
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(height: 8),
                              Text(
                                university.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal, // تغییر وزن فونت در حالت hover
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )

              ,
            ],
          ),
        ),
      ),

    );
  }
}
