import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Nomes de tabelas centralizados
  static const String usersTable = "users";
  static const String eventsTable = "events";
  static const String recurringEventsTable = "recurring_events";

  static const _databaseName = "app_database.db"; // Um nome unificado para o banco
  static const _databaseVersion = 2;

  // Instância única (Singleton)
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ✅ CRIA AS 3 TABELAS NO MESMO LUGAR
  Future<void> _onCreate(Database db, int version) async {
    // Usando exatamente a sua estrutura da tabela 'users'
    await db.execute('''
      CREATE TABLE $usersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $eventsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        date TEXT,
        time TEXT,
        isAllDay INTEGER,
        recurringRuleId INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE $recurringEventsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        startDate TEXT,
        endDate TEXT,
        daysOfWeek TEXT,
        time TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $recurringEventsTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          startDate TEXT,
          endDate TEXT,
          daysOfWeek TEXT
        )
      ''');
    }
  }
}