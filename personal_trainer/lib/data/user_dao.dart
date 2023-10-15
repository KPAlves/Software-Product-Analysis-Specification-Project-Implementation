import 'database_helper.dart';
import 'package:personal_trainer/data/user_model.dart';

class UserDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insere um novo usuário no banco de dados.
  Future<int> insertUser(UserModel user) async {
    final db = await _databaseHelper.database;
    return await db!.insert(DatabaseHelper.usersTable, user.toMap());
  }

  // Recupera todos os usuários do banco de dados.
  Future<List<UserModel>> getUsers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db!.query(DatabaseHelper.usersTable);
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  // Atualiza um usuário no banco de dados.
  Future<int> updateUser(UserModel user) async {
    final db = await _databaseHelper.database;
    return await db!.update(
      DatabaseHelper.usersTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Deleta um usuário do banco de dados com base no ID.
  Future<int> deleteUser(int id) async {
    final db = await _databaseHelper.database;
    return await db!.delete(
      DatabaseHelper.usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
