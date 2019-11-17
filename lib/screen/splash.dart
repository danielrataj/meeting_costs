import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meeting_costs/app/base_widget.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer _timer;

  void _initTimer() {
    _timer = Timer(Duration(), () async {
      Timer(Duration(seconds: 2), () async {
        setState(() {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _initTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2 - 150),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Meeting Costs',
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 40),
                      ),
                      Container(
                        height: 30,
                      ),
                      _timer.isActive
                          ? CircularProgressIndicator(
                              backgroundColor:
                                  Theme.of(context).textTheme.display2.color,
                            )
                          : Container()
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
