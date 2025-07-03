import 'package:sqflite/sqflite.dart';
import '../models/recurring_event_model.dart';
import 'database_service.dart'; // Importe o novo serviço

class RecurringEventDao {
  static const _tableName = "recurring_events";

  // Função para inserir um evento recorrente
  static Future<void> insertRecurringEvent(RecurringEventModel event) async {
    final db = await DatabaseService.instance.database; // Use o serviço
    await db.insert(
      _tableName,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateRecurringEvent(RecurringEventModel event) async {
    final db = await DatabaseService.instance.database;
    await db.update(
      _tableName,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  static Future<RecurringEventModel?> getRecurringEventById(int id) async {
    final db = await DatabaseService.instance.database;
    final result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return RecurringEventModel.fromMap(result.first);
    }
    return null;
  }

  // NOVA FUNÇÃO: Excluir uma regra de recorrência
  static Future<void> deleteRecurringEvent(int id) async {
    final db = await DatabaseService.instance.database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Função para buscar TODAS as regras de eventos recorrentes
  static Future<List<RecurringEventModel>> getAllRecurringEvents() async {
    final db = await DatabaseService.instance.database; // Use o serviço
    final result = await db.query(_tableName);

    return result.isNotEmpty
        ? result.map((e) => RecurringEventModel.fromMap(e)).toList()
        : [];
  }
}