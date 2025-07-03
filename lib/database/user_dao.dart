import '../models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class UserDao {
  static const String _tableName = DatabaseService.usersTable;

  static Future<void> insertUser(UserModel user) async {
    final db = await DatabaseService.instance.database;
    await db.insert(
      _tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> getUserByEmail(String email) async {
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

  /// Atualiza um usuário existente no banco de dados.
  static Future<void> updateUser(UserModel user) async {
    final db = await DatabaseService.instance.database;
    await db.update(
      _tableName,
      user.toMap(),
      where: 'id = ?', // Garante que estamos atualizando o usuário correto
      whereArgs: [user.id],
    );
  }
}