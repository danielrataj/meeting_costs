import 'package:flutter/material.dart';

final ThemeData mainTheme = new ThemeData(
    fontFamily: 'Cabin',
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color.fromRGBO(198, 255, 245, 1),
    accentColor: Color.fromRGBO(116, 171, 162, 1),
    textTheme: TextTheme(
      display1: TextStyle(color: Color.fromRGBO(170, 226, 217, 1)),
      display2: TextStyle(color: Color.fromRGBO(143, 198, 189, 1)),
      display3: TextStyle(color: Color.fromRGBO(116, 171, 162, 1)),
      body1: TextStyle(color: Color.fromRGBO(40, 93, 86, 1), fontSize: 22),
      body2: TextStyle(color: Color.fromRGBO(117, 128, 126, 1), fontSize: 18),
      headline:
          TextStyle(color: Color.fromRGBO(170, 226, 217, 1), fontSize: 40),
    ));
