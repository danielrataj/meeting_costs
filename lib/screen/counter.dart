import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:circle_wave_progress/circle_wave_progress.dart';
import 'package:meeting_costs/app/base_widget.dart';
import 'package:meeting_costs/model/Cost.dart';

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  Timer _timer;
  DateTime _now = DateTime.now();
  DateTime _datetime = DateTime.now();
  int _seconds = 0;
  bool _counterActive = false;
  List<PopupMenuItem> _menuItems = List();

  @override
  void initState() {
    super.initState();

    startCounter();
  }

  @override
  void dispose() {
    cancelTimer();

    _now = DateTime.now();
    _datetime = DateTime.now();
    _seconds = 0;

    super.dispose();
  }

  void cancelTimer() {
    _timer.cancel();
  }

  void stopCounter() {
    cancelTimer();

    setState(() {
      _counterActive = false;
    });
  }

  void startCounter() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        ++_seconds;
        _datetime = _now.add(Duration(seconds: _seconds));
      });
    });

    setState(() {
      _counterActive = true;
    });
  }

  simpleDurationFormat(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0");

  double countSpentForSeconds({CostModel costModel, int seconds}) {
    int divider = 31 * 24 * 60 * 60; // just in case we take "month" by default

    costModel.items.forEach((cost) {
      if (cost.per == CostPer.annualy.toString().split('.').last) {
        divider = 12 * 31 * 24 * 60 * 60;
      }

      if (cost.per == CostPer.monthly.toString().split('.').last) {
        divider = 31 * 24 * 60 * 60;
      }

      if (cost.per == CostPer.hourly.toString().split('.').last) {
        divider = 24 * 60 * 60;
      }
    });

    return ((costModel.total / divider) * _seconds);
  }

  Widget textWithPriceContainer({moneyPerSeconds}) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Theme.of(context).accentColor, width: 5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text((simpleDurationFormat(_datetime.difference(_now))).toString(),
              style: Theme.of(context).textTheme.body2.copyWith(fontSize: 25)),
          Divider(
            color: Theme.of(context).textTheme.display1.color,
          ),
          Text(moneyPerSeconds.toString(),
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30))
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final CostModel costModel = ModalRoute.of(context).settings.arguments;
    double spentPerSeconds =
        countSpentForSeconds(costModel: costModel, seconds: _seconds);
    String moneyPerSeconds =
        FlutterMoneyFormatter(amount: spentPerSeconds).output.nonSymbol;

    _menuItems = List()
      ..add(PopupMenuItem(
          enabled: !_counterActive, value: 1, child: Text('continue counting')))
      ..add(PopupMenuItem(
        enabled: _counterActive,
        value: 0,
        child: Text('stop counting'),
      ));

    return WillPopScope(
        onWillPop: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Reset counting"),
                  content: Text(
                      "Are you sure you want to go to the homepage and reset the counter?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
          return;
        },
        child: BaseWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  _counterActive
                      ? CircleWaveProgress(
                          borderColor: Theme.of(context).accentColor,
                          backgroundColor: Colors.transparent,
                          size: 200,
                          progress: 20,
                          borderWidth: 10.0)
                      : textWithPriceContainer(
                          moneyPerSeconds: moneyPerSeconds),
                  textWithPriceContainer(moneyPerSeconds: moneyPerSeconds)
                ],
              ),
              Container(
                height: 10,
              ),
              PopupMenuButton(
                tooltip: "settings",
                child: Ink(
                  decoration: ShapeDecoration(
                      color: Theme.of(context).textTheme.body2.color,
                      shape: CircleBorder()),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.settings, size: 40),
                  ),
                ),
                onSelected: (value) {
                  if (value == 0) {
                    stopCounter();
                  }

                  if (value == 1) {
                    startCounter();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return _menuItems;
                },
              )
            ],
          ),
        ));
  }
}
