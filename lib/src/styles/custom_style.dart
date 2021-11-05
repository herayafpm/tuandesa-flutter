import 'package:division/division.dart';
import 'package:flutter/material.dart';

abstract class CustomStyle {
  static var bgColor = Color(0xffC7ECEE);
  static var headerColor = Color(0xff0FBCF9);
  static var navBottomColor = Color(0xffDFF9FB);
  static var buttonColor = Color(0xff00B894);
  static ParentStyle cardStyle = ParentStyle()
    ..background.color(Colors.white)
    ..borderRadius(all: 5)
    ..elevation(5)
    ..padding(all: 5)
    ..margin(all: 5)
    ..ripple(true, splashColor: Colors.grey[400]);

  static ParentStyle buttonStyle = ParentStyle()
    ..background.color(CustomStyle.buttonColor)
    ..borderRadius(all: 50)
    ..elevation(3)
    ..margin(all: 10)
    ..minWidth(200)
    ..minHeight(40)
    ..ripple(true, splashColor: Colors.grey[400]);

  static TxtStyle textStyle = TxtStyle()
    ..textColor(Colors.black54)
    ..textAlign.justify()
    ..letterSpacing(1.0)
    ..fontSize(16);

  static ParentStyle imgStyle = ParentStyle()
    ..width(120)
    ..height(120)
    ..margin(all: 5)
    ..borderRadius(all: 10);
}
