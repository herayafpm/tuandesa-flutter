import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:tuandesa/src/styles/custom_style.dart';

class AuthLayout extends StatelessWidget {
  Widget body;
  AuthLayout({required this.body});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomStyle.bgColor,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Parent(
                  style: CustomStyle.imgStyle.clone()
                    ..background
                        .image(path: "images/logo.png", fit: BoxFit.cover)
                    ..margin(top: 40, bottom: 10),
                  child: Container(),
                ),
                Parent(
                  style: CustomStyle.cardStyle.clone()
                    ..background.color(Color(0xff0FBCF9))
                    ..borderRadius(all: 10)
                    ..width((MediaQuery.of(context).size.width - 40) * 1)
                    ..ripple(false)
                    ..padding(horizontal: 15, top: 20),
                  child: body,
                ),
                Parent(
                  style: ParentStyle()
                    ..height(50)
                    ..margin(top: 20),
                  child: Txt(
                    "Desa Kedunggede",
                    style: CustomStyle.textStyle.clone(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
