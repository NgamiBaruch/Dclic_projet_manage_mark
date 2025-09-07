import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import 'note.dart';

class NoteDao {
  Future<int> insert(Note note) async {
    final db = await AppDatabase.instance.database;
    return db.insert('notes', note.toMap());
  }

  Future<int> update(Note note) async {
    final db = await AppDatabase.instance.database;
    if (note.id == null) throw ArgumentError('Note.id requis pour update');
    return db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> getAll() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('notes', orderBy: 'updatedAt DESC');
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<Note?> getById(int id) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('notes', where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isEmpty) return null;
    return Note.fromMap(maps.first);
  }
}
