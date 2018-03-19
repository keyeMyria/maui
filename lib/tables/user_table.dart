import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:maui/models/user.dart';
import 'package:maui/app_database.dart';

class UserTable {
  Future<User> getUser(String id) async {
    var db = await new AppDatabase().getDb();
    List<Map> maps = await db.query(User.table,
        columns: [User.columnId, User.columnName, User.columnImage],
        where: "${User.columnId} = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getUsers() async {
    var db = await new AppDatabase().getDb();
    List<Map> maps = await db.query(User.table,
        columns: [User.columnId, User.columnName, User.columnImage]);
    return maps.map((userMap) => new User.fromMap(userMap)).toList();
  }


  Future<User> insert(User user) async {
    var db = await new AppDatabase().getDb();
    user.id = new Uuid().v1();
    await db.insert(User.table, user.toMap());
    return user;
  }

  Future<int> delete(int id) async {
    var db = await AppDatabase().getDb();
    return await db.delete(User.table, where: "${User.columnId} = ?", whereArgs: [id]);
  }

  Future<int> update(User user) async {
    var db = await AppDatabase().getDb();
    return await db.update(User.table, user.toMap(),
        where: "${User.columnId} = ?", whereArgs: [user.id]);
  }

}