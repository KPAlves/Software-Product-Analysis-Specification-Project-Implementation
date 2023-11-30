import 'package:flutter/material.dart';
import 'package:personal_trainer/app.dart';
import 'package:personal_trainer/data/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o banco de dados antes de criar instâncias de classes dependentes do banco de dados.
  await DatabaseHelper.instance.initializeDatabase();

  runApp(const PersonalTrainerApp());
}
