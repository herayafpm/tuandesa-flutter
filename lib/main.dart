import 'package:flutter/material.dart';
import 'package:tuandesa/splashscreen_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      title: "Tuandesa",
      home: SplashScreenView(),
    );
  }
}
