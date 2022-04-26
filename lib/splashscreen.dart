import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_editor_new/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 5),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return HomePage();
            },
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red.withOpacity(0.3),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FlutterLogo(
              textColor: Colors.black,
              size: 100,
              duration: Duration(seconds: 5),
              curve: Curves.slowMiddle,
              style: FlutterLogoStyle.markOnly,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "FLUTTER",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator()
          ]),
        ),
      ),
    );
  }
}
