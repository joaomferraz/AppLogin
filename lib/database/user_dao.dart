import '../models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'database_service.dart'; // Importe o serviço central

class UserDao {
  // ✅ USA O NOME DA TABELA DEFINIDO NO SERVIÇO
  static const String _tableName = DatabaseService.usersTable;

  // ❌ A FUNÇÃO _getDatabase() FOI REMOVIDA

  static Future<void> insertUser(UserModel user) async {
    // ✅ USA A INSTÂNCIA DO SERVIÇO
    final db = await DatabaseService.instance.database;
    await db.insert(
      _tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    // ✅ USA A INSTÂNCIA DO SERVIÇO
    final db = await DatabaseService.instance.database;
    final result = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }
}