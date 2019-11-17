import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:meeting_costs/model/Cost.dart' as CostModel;

class Costs extends StatefulWidget {
  final List<CostModel.Cost> costs;

  const Costs({Key key, this.costs}) : super(key: key);

  @override
  _CostsState createState() => _CostsState();
}

class _CostsState extends State<Costs> {
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.costs.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding:
                  EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    size: 30,
                                  ),
                                  Text("(${widget.costs[index].multiply})",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .display3
                                              .color))
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  FlutterMoneyFormatter(
                                          amount:
                                              widget.costs[index].totalValue)
                                      .output
                                      .nonSymbol,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                                Text(
                                  widget.costs[index].per.toString(),
                                  style: Theme.of(context).textTheme.body2,
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Icon(Icons.add_circle_outline,
                                  size: 40,
                                  color:
                                      Theme.of(context).textTheme.body2.color),
                              onTap: () async {
                                Provider.of<CostModel.CostModel>(context,
                                        listen: false)
                                    .multiply(
                                        cost: widget.costs.elementAt(index),
                                        multiply: 1);
                              },
                            ),
                            GestureDetector(
                              child: Icon(Icons.remove_circle_outline,
                                  size: 40,
                                  color:
                                      Theme.of(context).textTheme.body2.color),
                              onTap: () async {
                                if (widget.costs.elementAt(index).multiply ==
                                    1) {
                                  // destroy record
                                  Provider.of<CostModel.CostModel>(context,
                                          listen: false)
                                      .delete(widget.costs.elementAt(index));
                                } else {
                                  // decrease
                                  Provider.of<CostModel.CostModel>(context,
                                          listen: false)
                                      .multiply(
                                          cost: widget.costs.elementAt(index),
                                          multiply: -1);
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
