import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DbManagerTest {
  Database _database;

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), 'test.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db
          .execute('CREATE TABLE test (id INTEGER, name TEXT, course TEXT)');
    });
  }

  Future<int> insertStudent(StudentTest student) async {
    await openDb();
    return _database.insert('test', student.toMap());
  }

  Future<List<StudentTest>> getStudentList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('test');
    return List.generate(maps.length, (i) {
      return StudentTest(
          id: maps[i]['id'], name: maps[i]['name'], course: maps[i]['course']);
    });
  }

  Future<int> updateStudent(StudentTest student) async {
    await openDb();
    return _database.update('test', student.toMap(),
        where: "id = ?", whereArgs: [student.id]);
  }

  Future<void> deleteStudent(int id) async {
    await openDb();
    await _database.delete('test', where: "id = ?", whereArgs: [id]);
  }
}

class StudentTest {
  int id;
  String name;
  String course;

  StudentTest({@required this.name,@required this.course, this.id});

  Map<String, dynamic> toMap() {
    return {'name': name, 'course': course};
  }
}
