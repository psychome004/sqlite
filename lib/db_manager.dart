import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

class DbManager {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), 'student.db'),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE student (id INTEGER PRIMARYKEY, name TEXT, course TEXT)');
      });
    }
  }

  //Insert Data
  Future<int> insertStudent(Student student) async {
    await openDb();
    return await _database.insert('student', student.toMap());
  }

  //Get Data
  Future<List<Student>> getStudentList() async {
    await openDb();
    List<Map<String, dynamic>> maps = await _database.query('student');
    return List.generate(maps.length, (i) {
      return Student(
          id: maps[i]['id'], name: maps[i]['name'], course: maps[i]['course']);
    });
  }

  Future<int> updateStudent(Student student) async {
    await openDb();
    return await _database.update('student', student.toMap(),
        where: "id = ?", whereArgs: [student.id]);
  }

  Future<int> deleteStudent(int id) async {
    await openDb();
    return await _database.delete('student', where: "id = ?", whereArgs: [id]);
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
