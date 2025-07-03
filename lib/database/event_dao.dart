import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event_model.dart';

class EventDao {
  static const _databaseName = "events.db";
  static const _tableName = "events";

  // Função para obter o banco de dados
  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  // Função para inserir um evento
  static Future<void> insertEvent(EventModel event) async {
    final db = await _getDatabase();
    await db.insert(
      _tableName,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

static Future<List<EventModel>> getEventsForMonth(DateTime month) async {
    final db = await _getDatabase();

    // Calcula o primeiro e o último dia do mês
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0); // Truque para pegar o último dia

    final result = await db.query(
      _tableName,
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        firstDayOfMonth.toIso8601String(),
        // Adiciona o fim do dia para garantir que todos os eventos do último dia sejam incluídos
        lastDayOfMonth.toIso8601String().substring(0, 10) + ' 23:59:59.999',
      ],
    );

    return result.isNotEmpty
        ? result.map((e) => EventModel.fromMap(e)).toList()
        : [];
  }

  // Função para buscar os eventos por data
  static Future<List<EventModel>> getEventsByDate(DateTime date) async {
    final db = await _getDatabase();
    final result = await db.query(
      _tableName,
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );
    
    return result.isNotEmpty
        ? result.map((e) => EventModel.fromMap(e)).toList()
        : [];
  }
}
