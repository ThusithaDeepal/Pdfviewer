import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import dart:async;

class DatabaseHelper {
  static final _dbName = 'pdfViewer.db';
  static final _dbVersion = 1;
  static final _tableName = "pdfDownload";
  static final columnId = 'id';
  static final fileName = 'fileName';
  static final downloadStatus = "downloadStatus";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initiateDatabase();
      List booklist = [
        'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-01.pdf',
        'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-02.pdf',
        'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-03.pdf',
        'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-04.pdf',
        'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-05.pdf',
        'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-06.pdf',
        'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-07.pdf',
        'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-08.pdf',
        'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-09.pdf',
      ];
      // booklist.forEach((element) {
      //   _database.insert(_tableName, {
      //     DatabaseHelper.fileName: booklist[element],
      //     DatabaseHelper.downloadStatus: false,
      //   });
      // });
      //
      for (int i = 0; i < booklist.length; i++) {
        _database.insert(_tableName, {
          DatabaseHelper.fileName: booklist[i],
          DatabaseHelper.downloadStatus: false,
        });
      }

      return _database;
    }
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    return db.execute('''
  CREATE TABLE $_tableName(
$columnId INTEGER PRIMARY KEY,
$fileName TEXT,
$downloadStatus TEXT

  )
  ''');
  }

  // {"Id":1,
  // "name":"thusitha"}  //need to have this format key value pair
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row); //return id of the row inserted
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<List<Map<String, dynamic>>> queryId(String filenNameSearch) async {
    Database db = await instance.database;
    return await db
        .query(_tableName, where: '$fileName=?', whereArgs: [filenNameSearch]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    String fileNameUpdate = row['fileName'];
    Database db = await instance.database;
    return await db.update(_tableName, row,
        where: '$fileName = ?', whereArgs: [fileNameUpdate]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId=?', whereArgs: [id]);
  }
}
