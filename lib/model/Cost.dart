import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum CostPer { hourly, monthly, annualy }

class CostModel extends ChangeNotifier {
  static final int version = 1;

  final List<Cost> _items = [];

  Future<Database> get database async {
    return openDatabase(join(await getDatabasesPath(), 'meeting_cost.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE cost(id INTEGER PRIMARY KEY autoincrement, type INTEGER NOT NULL DEFAULT 1, value REAL, multiply INTEGER NOT NULL DEFAULT 1, per TEXT CHECK( per IN ('${CostPer.hourly.toString().split('.').last}','${CostPer.monthly.toString().split('.').last}','${CostPer.annualy.toString().split('.').last}') ))",
      );
    }, version: version);
  }

  List<Cost> get items => _items;

  bool get hasItems => _items.length > 0;

  int get total => _items.length > 0
      ? _items
          .map<int>((m) => m.value.toInt() * m.multiply)
          .reduce((a, b) => a + b)
      : 0;

  Future<List<Cost>> findAll() async {
    final db = await database;

    var dbAll = await db.query("cost");

    _items.clear();

    dbAll.forEach((Map<String, dynamic> result) {
      _items.add(Cost(
          id: result["id"],
          type: result["type"],
          value: result["value"],
          multiply: result["multiply"],
          per: result["per"]));
    });

    notifyListeners();

    return _items;
  }

  void insert(Cost cost) async {
    final db = await database;

    await db.insert('cost', cost.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    _items.add(cost);

    notifyListeners();
  }

  void delete(Cost cost) async {
    final db = await database;
    await db.delete('cost', where: 'id = ?', whereArgs: [cost.id]);

    _items.remove(cost);

    notifyListeners();
  }

  void multiply({Cost cost, num multiply: 1}) async {
    final db = await database;
    var costItem = cost.toMap();
    costItem['multiply'] =
        (costItem['multiply'] == null ? 1 : costItem['multiply']);
    costItem['multiply'] = costItem['multiply'] + multiply;

    await db.update('cost', costItem, where: 'id = ?', whereArgs: [cost.id]);

    notifyListeners();
  }
}

class Cost {
  static const int TYPE_ATTENDEE = 1;

  final int id;
  final int type;
  final double value;
  final int multiply;
  final String per;

  Cost(
      {this.id,
      @required this.type,
      @required this.value,
      this.multiply,
      this.per});

  double get totalValue {
    if (this.value != null) {
      return this.value * this.multiply;
    }

    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'multiply': multiply,
      'per': per
    };
  }
}
