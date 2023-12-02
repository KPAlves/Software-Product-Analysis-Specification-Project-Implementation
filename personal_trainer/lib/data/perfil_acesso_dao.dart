import 'package:personal_trainer/data/perfil_acesso_model.dart';

import 'database_helper.dart';

class PerfilAcessoDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  
  Future<int> insertPerfilAcesso(PerfilAcessoModel perfilAcesso) async {
    final db = await _databaseHelper.database;
    return await db!.insert(DatabaseHelper.perfilAcessoTable, perfilAcesso.toMap());
  }

  Future<List<PerfilAcessoModel>> getPerfilAcesso() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db!.query(DatabaseHelper.perfilAcessoTable);
    return List.generate(maps.length, (i) {
      return PerfilAcessoModel.fromMap(maps[i]);
    });
  }

  Future<int> updatePerfilAcesso(PerfilAcessoModel perfil) async {
    final db = await _databaseHelper.database;
    return await db!.update(
      DatabaseHelper.perfilAcessoTable,
      perfil.toMap(),
      where: 'id = ?',
      whereArgs: [perfil.id],
    );
  }

  Future<int> deletePerfilAcesso(int id) async {
    final db = await _databaseHelper.database;
    return await db!.delete(
      DatabaseHelper.perfilAcessoTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}