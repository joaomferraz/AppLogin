import 'package:sqflite/sqflite.dart';
import '../models/event_model.dart';
import 'database_service.dart';

class EventDao {
  static const _tableName = "events";

  static Future<void> insertEvent(EventModel event) async {
    final db = await DatabaseService.instance.database;
    await db.insert(
      _tableName,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateEvent(EventModel event) async {
    final db = await DatabaseService.instance.database;
    await db.update(
      _tableName,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  static Future<void> deleteEvent(int id) async {
    final db = await DatabaseService.instance.database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<EventModel>> getEventsByDate(DateTime date) async {
    final db = await DatabaseService.instance.database;
    final result = await db.query(
      _tableName,
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );

    return result.isNotEmpty
        ? result.map((e) => EventModel.fromMap(e)).toList()
        : [];
  }

  static Future<List<EventModel>> getEventsForMonth(DateTime month) async {
    final db = await DatabaseService.instance.database;
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    final result = await db.query(
      _tableName,
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        firstDayOfMonth.toIso8601String(),
        '${lastDayOfMonth.toIso8601String().substring(0, 10)} 23:59:59.999',
      ],
    );

    return result.isNotEmpty
        ? result.map((e) => EventModel.fromMap(e)).toList()
        : [];
  }
}
