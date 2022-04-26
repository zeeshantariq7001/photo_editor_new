import 'package:flutter/material.dart';
import 'package:photo_editor_new/homepage.dart';
import 'package:photo_editor_new/splashscreen.dart';
import 'package:photo_editor_new/test.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (BuildContext context, Orientation, ScreenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
