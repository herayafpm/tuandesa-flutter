import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/pages/auth/login.dart';
import 'package:tuandesa/src/ui/pages/user/home_page_view.dart';

class SplashScreenView extends StatefulWidget {
  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        if (prefs.containsKey('token')) {
          return HomePageView();
        }
        return LoginPage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomStyle.bgColor,
      body: Center(
        child: Image.asset(
          "images/splash.png",
          width: 400.0,
          height: 300.0,
        ),
      ),
    );
  }
}
