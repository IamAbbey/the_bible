import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:the_bible/models/model.dart';
import 'package:meta/meta.dart';

class DBRepository {
  Database database;
  Future<void> initializeDB(String dbFileName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbFileName);

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "db", dbFileName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    database = await openDatabase(path, readOnly: true);
  }

  Future<List<Book>> fetchBooks() async {
    // Get a reference to the database.
    if (database == null) {
      throw NullThrownError();
    }

    final List<Map<String, dynamic>> bookQueryResponse =
        await database.query('books');

    return bookQueryResponse.map((e) => Book.fromMap(e)).toList();
  }

  Future<List<Chapter>> fetchBookChapters({@required int bookNumber}) async {
    // Get a reference to the database.
    if (database == null) {
      throw NullThrownError();
    }

    final List<Map<String, dynamic>> chapterQueryResponse = await database
        .query('stories', where: 'book_number = ?', whereArgs: [bookNumber]);

    return chapterQueryResponse.map((e) => Chapter.fromMap(e)).toList();
  }

  Future<List<Verse>> fetchBookVerses(
      {@required int bookNumber, @required int chapterNumber}) async {
    // Get a reference to the database.
    if (database == null) {
      throw NullThrownError();
    }

    final List<Map<String, dynamic>> verseQueryResponse = await database.query(
      'verses',
      where: 'book_number = ? AND chapter = ?',
      whereArgs: [bookNumber, chapterNumber],
    );
    return verseQueryResponse.map((e) => Verse.fromMap(e)).toList();
  }
}
