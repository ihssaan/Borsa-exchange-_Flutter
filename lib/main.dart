import 'borsa.dart';
import 'model.dart';
import 'package:flutter/material.dart';
import 'servis.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BorsaScreen(),
    );
  }
}
