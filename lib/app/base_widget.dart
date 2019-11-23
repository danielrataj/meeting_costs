import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meeting_costs/model/Cost.dart';
import 'package:meeting_costs/model/App.dart';

class BaseWidget extends StatefulWidget {
  const BaseWidget({Key key, this.child, this.appBar = false})
      : super(key: key);

  final Widget child;
  final bool appBar;

  @override
  _BaseWidgetState createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: widget.appBar ? AppBar() : null,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromRGBO(198, 255, 245, 1),
                Color.fromRGBO(198, 255, 255, .8),
                Color.fromRGBO(198, 255, 245, .6),
                Color.fromRGBO(255, 255, 245, .4)
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [.5, .6, .8, 1],
              tileMode: TileMode.clamp),
        ),
        child: Builder(builder: (BuildContext context) {
          return MultiProvider(providers: [
            ChangeNotifierProvider(builder: (context) => CostModel()),
            ChangeNotifierProvider(
                builder: (context) => AppModel(scaffoldKey: _scafoldKey)),
          ], child: widget.child);
        }),
      ),
    );
  }
}
