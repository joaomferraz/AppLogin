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

  // Função para buscar TODAS as regras de eventos recorrentes
  static Future<List<RecurringEventModel>> getAllRecurringEvents() async {
    final db = await DatabaseService.instance.database; // Use o serviço
    final result = await db.query(_tableName);

    return result.isNotEmpty
        ? result.map((e) => RecurringEventModel.fromMap(e)).toList()
        : [];
  }
}