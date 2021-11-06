import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/models/response_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/pages/user/berita/berita_view.dart';
import 'package:tuandesa/src/ui/pages/user/menu/menu_view.dart';
import 'package:tuandesa/src/ui/pages/user/profile/myprofile_view.dart';
import 'package:connectivity/connectivity.dart';

class HomePageView extends StatefulWidget {
  HomePageView() : super();

  @override
  State<StatefulWidget> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value("ok");
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setProfile();
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setProfile();
        break;
    }
  }

  void setProfile() async {
    try {
      await ProfileModel(
              alamat: '',
              createdAt: '',
              email: '',
              id: '',
              name: '',
              nik: '',
              noHP: '',
              ttl: '',
              type: '')
          .getProfile(context);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  int _selectedTabIndex = 0;
  final Color backgroundColor = Color(0xffC7ECEE);
  void onNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = <Widget>[BeritaView(), MenuView(), MyProfileView()];
    final _bottomNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Image.asset("images/home.png", width: 30, height: 30),
          title: Text("Home")),
      BottomNavigationBarItem(
          icon: Image.asset("images/menu.png", width: 30, height: 30),
          title: Text("Menu")),
      BottomNavigationBarItem(
          icon: Image.asset("images/profile.png", width: 30, height: 30),
          title: Text("Profile")),
    ];
    final _bottomNavBar = BottomNavigationBar(
        backgroundColor: CustomStyle.navBottomColor,
        items: _bottomNavBarItems,
        currentIndex: _selectedTabIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: onNavBarTapped);
    return Scaffold(
        backgroundColor: CustomStyle.bgColor,
        body: Center(
          child: _listPage[_selectedTabIndex],
        ),
        bottomNavigationBar: _bottomNavBar);
  }
}
