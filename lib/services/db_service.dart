import 'dart:async';
import 'package:path/path.dart';
import 'package:shopkite_demo/models/product.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  DbService._privateConstructor();

  static final DbService instance = DbService._privateConstructor();

  static late Database _database;

  _openDb() async {
    var db = await openDatabase(join(await getDatabasesPath(), "products.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE products(id INTEGER PRIMARY KEY autoincrement, name TEXT, price DOUBLE)",
      );
    });
    _database = db;
  }

  Future insertProduct(Product product) async {
    await _openDb();
    return await _database.insert('products', product.toJson());
  }

  Future<List<Product>> getProductList() async {
    await _openDb();
    final List<Map<String, dynamic>> maps = await _database.query('products');

    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
      );
    });
  }

  Future<void> deleteProduct(Product product) async {
    await _openDb();
    await _database
        .delete('products', where: "id = ?", whereArgs: [product.id]);
  }
}
