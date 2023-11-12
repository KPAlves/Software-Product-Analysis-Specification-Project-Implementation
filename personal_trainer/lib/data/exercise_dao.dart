import 'database_helper.dart';
import 'package:personal_trainer/data/exercise_model.dart';

class ExerciseDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insere um novo exercício no banco de dados.
  Future<int> insertExercise(ExerciseModel exercise) async {
    final db = await _databaseHelper.database;
    return await db!.insert(DatabaseHelper.exercisesTable, exercise.toMap());
  }

  // Recupera todos exercícios do banco de dados.
  Future<List<ExerciseModel>> getExercises() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db!.query(DatabaseHelper.exercisesTable);
    return List.generate(maps.length, (i) {
      return ExerciseModel.fromMap(maps[i]);
    });
  }

  // Atualiza exercício no banco de dados.
  Future<int> updateExercise(ExerciseModel exercise) async {
    final db = await _databaseHelper.database;
    return await db!.update(
      DatabaseHelper.exercisesTable,
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  // Deleta exercício do banco de dados com base no ID.
  Future<int> deleteExercise(int id) async {
    final db = await _databaseHelper.database;
    return await db!.delete(
      DatabaseHelper.exercisesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
