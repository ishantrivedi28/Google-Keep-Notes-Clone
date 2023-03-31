import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_keep_notes/Models/MyNoteModel.dart';
import 'package:google_keep_notes/services/firestore_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  String dbpath = '';
  static final NotesDatabase instance = NotesDatabase._initDB();
  static Database? _database;
  NotesDatabase._initDB();

  Future<Database?> get database async {
    final path = join(await getDatabasesPath(), 'Notes.db');
    if (_database != null && File(path).existsSync()) return _database;
    _database = await _initializeDB('Notes.db');
    return _database;
  }

  Future<Database> _initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    dbpath = path;
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
  CREATE TABLE Notes(
    ${NotesImpNames.id} $idType,
    ${NotesImpNames.uniqueId} $textType,
    ${NotesImpNames.pin} $boolType,
    ${NotesImpNames.title} $textType,
    ${NotesImpNames.content} $textType,
    ${NotesImpNames.createdTime} $textType
  )
''');
  }

  Future<Note?> insertEntry(Note note) async {
    await FireDB().createNewNoteFirestore(note);
    final db = await instance.database;
    final id = await db!.insert(NotesImpNames.TableName, note.toJson());
    return note.copy(id: id);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    print(db);
    final orderBy = '${NotesImpNames.createdTime} ASC';

    final query_result =
        await db!.query(NotesImpNames.TableName, orderBy: orderBy);
    return query_result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> readOneNote(int id) async {
    final db = await instance.database;
    final map = await db!.query(NotesImpNames.TableName,
        columns: NotesImpNames.values,
        where: '${NotesImpNames.id} = ?',
        whereArgs: [id]);
    if (map.isNotEmpty) {
      print(map);
      return Note.fromJson(map.first);
    } else
      return null;
  }

  Future<int> updateNote(Note note) async {
    await FireDB().updateNoteFirestore(note);
    final db = await instance.database;
    return await db!.update(NotesImpNames.TableName, note.toJson(),
        where: "${NotesImpNames.id} = ?", whereArgs: [note.id]);
  }

  Future deleteNote(Note? note) async {
    await FireDB().deleteNoteFirestore(note!);
    final db = await instance.database;
    await db!.delete(NotesImpNames.TableName,
        where: "${NotesImpNames.id} = ?", whereArgs: [note.id]);
  }

  Future closeDB() async {
    final db = await instance.database;

    db!.close();
  }

  Future<List<int>> getNoteString(String query) async {
    final db = await instance.database;
    final result = await db!.query(NotesImpNames.TableName);
    List<int> resultIDs = [];
    result.forEach((element) {
      if (element["title"].toString().toLowerCase().contains(query) ||
          element["content"].toString().toLowerCase().contains(query))
        resultIDs.add(element["id"] as int);
    });

    return resultIDs;
  }

  Future<int> pinNote(Note? note) async {
    final db = await instance.database;
    return await db!.update(
        NotesImpNames.TableName, {NotesImpNames.pin: !note!.pin ? 1 : 0},
        where: "${NotesImpNames.id} = ?", whereArgs: [note.id]);
  }

  Future deleteSQLDB() async {
    await deleteDatabase(dbpath);
  }
}
