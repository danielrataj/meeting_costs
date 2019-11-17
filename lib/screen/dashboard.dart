import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meeting_costs/app/base_widget.dart';
import 'package:meeting_costs/routes.dart';
import 'package:meeting_costs/model/Cost.dart';
import 'package:meeting_costs/ui/Costs.dart' as UICosts;
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _futureReady = false;

  Future<void> _onBack(BuildContext context) async {
    // prevent app from closing
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBack(context),
      child: BaseWidget(
        child: Column(
          children: <Widget>[
            Consumer<CostModel>(
              builder: (BuildContext context, costs, child) {
                return FutureBuilder(
                    future: costs.findAll(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Cost>> snapshot) {
                      if (snapshot.hasError) {
                        return Text("There is some error under the hood.");
                      }

                      if (!snapshot.hasData) {
                        return Container();
                      }

                      _futureReady = true;

                      return Expanded(
                        child: Column(
                          children: <Widget>[
                            snapshot.hasData && snapshot.data.length > 0
                                ? UICosts.Costs(costs: snapshot.data)
                                : Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.face,
                                          size: 50,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            "There are no costs at this time yet. You should start adding a new one.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      );
                    });
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Consumer<CostModel>(builder: (context, costs, child) {
                      return _futureReady && costs.hasItems
                          ? FloatingActionButton.extended(
                              heroTag: null,
                              icon: Icon(Icons.timer),
                              label: Text('start'),
                              onPressed: () {
                                Navigator.of(context).pushNamed(Routes.counter,
                                    arguments: costs);
                              },
                              backgroundColor:
                                  Theme.of(context).textTheme.display1.color)
                          : Container();
                    }),
                    Consumer<CostModel>(builder: (context, costs, child) {
                      return Builder(
                        builder: (BuildContext context) {
                          return _futureReady
                              ? FloatingActionButton.extended(
                                  heroTag: null,
                                  backgroundColor: Theme.of(context)
                                      .textTheme
                                      .display2
                                      .color,
                                  key: Key('add'),
                                  label: Text('add cost'),
                                  onPressed: () {
                                    showBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                              child: Container(
                                                  child: Wrap(
                                                children: <Widget>[
                                                  ListTile(
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      leading: Icon(
                                                          Icons.person_add),
                                                      title: Text('attendee'),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                Routes.person);
                                                      }),
                                                  Container(
                                                    height: 50,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.grey[300]),
                                                    child: ListTile(
                                                        title: Text(
                                                          'cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        onTap: () =>
                                                            Navigator.pop(
                                                                context)),
                                                  )
                                                ],
                                              )),
                                            ));
                                  },
                                  icon: Icon(Icons.keyboard_arrow_up))
                              : Container();
                        },
                      );
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
