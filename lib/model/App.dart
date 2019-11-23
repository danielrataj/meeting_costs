import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AppModel({this.scaffoldKey});
}
