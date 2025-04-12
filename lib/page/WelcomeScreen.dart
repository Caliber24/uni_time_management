import 'dart:async';
import 'package:flutter/material.dart';
import 'SelectUniver.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UniversityPage()),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF254EDB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(

              child: Center(
                child: Image.asset(
                  'assets/1.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              "نرم افزار نمایش واحد",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
