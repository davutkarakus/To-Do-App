import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_flutter1/models/todo.dart';

class DbHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initializeDb();
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "etrade.db");
    print(dbPath);
    var eTradeDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTradeDb;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        "Create table todos(id integer primary key AUTOINCREMENT NOT NULL,todoText text,checked integer)");
  }

  Future<List<todo>> getTodos() async {
    Database? db = await this.db;
    print("${db}alooo");
    var result = await db?.query("todos");
    print(result);
    return List.generate(
        result!.length, (index) => todo.fromObject(result[index]));
  }

  Future<int?> insert(todo Todo) async {
    Database? db = await this.db;
    var result = await db?.insert("todos", Todo.toMap());
    return result;
  }

  Future<int?> delete(int id) async {
    Database? db = await this.db;
    var result = await db?.rawDelete("delete from todos where id=$id");
    print("değer nedir $result");
    return result;
  }

  Future<int?> update(todo Todo) async {
    Database? db = await this.db;
    var result = await db
        ?.update("todos", Todo.toMap(), where: "id=?", whereArgs: [Todo.id]);
    return result;
  }
}
