import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:meeting_costs/routes.dart';
import 'package:meeting_costs/theme/main.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = new Router();

  @override
  void initState() {
    super.initState();

    Routes.configureRoutes(_router);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: _router.generator,
        supportedLocales: [
          Locale('en', ''),
        ],
        initialRoute: '/',
        theme: mainTheme);
  }
}
