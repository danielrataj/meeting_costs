import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:meeting_costs/screen/dashboard.dart' as Screen;
import 'package:meeting_costs/screen/splash.dart' as Screen;
import 'package:meeting_costs/screen/person.dart' as Screen;
import 'package:meeting_costs/screen/counter.dart' as Screen;

var rootHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Screen.Splash();
});

var dashboardHome = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Screen.Dashboard();
});

var personScreen = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Screen.Person();
});

var counterScreen = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Screen.Counter();
});

class Routes {
  static String root = '/';
  static String dashboard = '/dashboard';
  static String person = '/person';
  static String counter = '/counter';

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('Route not found!');
      return Container();
    });
    router.define(root, handler: rootHandler);
    router.define(dashboard, handler: dashboardHome);
    router.define(person, handler: personScreen);
    router.define(counter, handler: counterScreen);
  }
}
