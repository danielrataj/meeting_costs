import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meeting_costs/model/Cost.dart';

class BaseWidget extends StatefulWidget {
  const BaseWidget({Key key, this.child, this.appBar = false}) : super(key: key);

  final Widget child;
  final bool appBar;

  @override
  _BaseWidgetState createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ? AppBar(): null,
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
        child: MultiProvider(providers: [
          ChangeNotifierProvider(builder: (context) => CostModel())
        ], child: widget.child),
      ),
    );
  }
}
