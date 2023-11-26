import 'package:flutter/material.dart';
import 'package:personal_trainer/data/database_helper.dart';
import 'package:personal_trainer/screens/login_page_screen.dart';
import 'package:personal_trainer/theme/personalTrainerTheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o banco de dados antes de criar instâncias de classes dependentes do banco de dados.
  await DatabaseHelper.instance.initializeDatabase();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Personal Trainer',
      debugShowCheckedModeBanner: false,
      theme: PersonalTrainerTheme().buildPersonalTrainerTheme(),
      home: const LoginPageScreen(),
    );
  }
}