import 'package:uni_time_management/page/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:uni_time_management/page/ShowProfSchedule.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShowProfSchedule(),
    );
  }
}




