import 'package:flutter/material.dart';
import 'package:photo_editor/practicestackboard/test_widget.dart';

import 'beziercurves/beziercurves.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Photo Editor With Draft',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const TestWidgetForStackboard()
        // const BezierCurve(
        //   title: 'Bezier Curve',
        // ),
        );
  }
}
