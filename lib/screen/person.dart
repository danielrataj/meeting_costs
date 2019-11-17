import 'package:flutter/material.dart';
import 'package:meeting_costs/app/base_widget.dart';
import 'package:meeting_costs/routes.dart';
import 'package:meeting_costs/model/Cost.dart';
import 'package:provider/provider.dart';

class Person extends StatefulWidget {
  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  final _formKey = GlobalKey<FormState>();
  double _costValue = 0;
  String _selectedTimeSalary = CostPer.monthly.toString().split('.').last;

  Widget build(BuildContext context) {
    return BaseWidget(
      child: Container(
        padding: EdgeInsets.only(top: 50, left: 10, bottom: 10, right: 10),
        child: Stack(children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Salary',
                  style:
                      Theme.of(context).textTheme.body1.copyWith(fontSize: 20),
                ),
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter salary for the atendee.';
                    }

                    try {
                      setState(() {
                        _costValue = double.tryParse(value);
                      });
                    } catch (e) {
                      return 'Salary has to be a number withou decimal points.';
                    }

                    return null;
                  },
                  onSaved: (val) => setState(() => () {
                        _costValue = double.tryParse(val);
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Text(
                  'Rate',
                  style:
                      Theme.of(context).textTheme.body1.copyWith(fontSize: 20),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  iconSize: 30,
                  value: _selectedTimeSalary,
                  items: <String>[
                    CostPer.hourly.toString().split('.').last,
                    CostPer.monthly.toString().split('.').last,
                    CostPer.annualy.toString().split('.').last
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() {
                      _selectedTimeSalary = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Builder(
              builder: (BuildContext context) {
                return FloatingActionButton.extended(
                  backgroundColor: Theme.of(context).textTheme.display2.color,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      Provider.of<CostModel>(context, listen: false).insert(
                          Cost(
                              type: Cost.TYPE_ATTENDEE,
                              value: _costValue,
                              per: _selectedTimeSalary));

                      Navigator.of(context).pushNamed(Routes.dashboard);
                    }
                  },
                  label: Text('add'),
                  icon: Icon(Icons.add),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
