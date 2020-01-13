import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  Database _database;
//  Rename the Table, if there is an error
  String dbName = 'course.db';
  String tableName = 'employee';

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), dbName),
          version: 1,
          onCreate: (Database db, int version) async {
              await db.execute("CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, course TEXT)");
          }
      );
    }
  }

  //Insert Data
  Future<int> insertStudent(Student student) async {
    await openDb();
    return await _database.insert(
        tableName,
        student.toMap()
    );
  }

  //Get Data
  Future<List<Student>> getStudentList() async {
    await openDb();
    List<Map<String, dynamic>> maps = await _database.query(tableName);
    return List.generate(maps.length, (i) {
      return Student(
          id: maps[i]['id'],
          name: maps[i]['name'],
          course: maps[i]['course']
      );
    });
  }

  Future<int> updateStudent(Student student) async {
    await openDb();
    return await _database.update(
        tableName,
        student.toMap(),
        where: "id = ?",
        whereArgs: [student.id]
    );
  }

  Future<void> deleteStudent(int id) async {
    await openDb();
    return await _database.delete(
        tableName,
        where: "id = ?",
        whereArgs: [id]
    );
  }
}

class Student {
  int id;
  String name;
  String course;

  Student({@required this.name, @required this.course, this.id});

  Map<String, dynamic> toMap() {
    return {'name': name, 'course': course};
  }
}
