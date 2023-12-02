import 'package:flutter/material.dart';
import 'package:personal_trainer/screens/home_screen.dart';
import 'package:personal_trainer/theme/backdrop_theme.dart';
import 'package:personal_trainer/screens/login_screen.dart';
import 'package:personal_trainer/screens/menu_screen.dart';
import 'package:personal_trainer/theme/app_theme.dart';

class PersonalTrainerApp extends StatefulWidget {
  const PersonalTrainerApp({super.key});

  @override
  State<PersonalTrainerApp> createState() => _PersonalTrainerAppState();
}

class _PersonalTrainerAppState extends State<PersonalTrainerApp> {
  
  //TODO: alterar Category e nome da variável
  
  Category _currentCategory = Category.planilha;
  Widget _frontTitle = Text('Personal Trainer');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PersonalTrainer',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginScreen(),
        '/': (BuildContext context) => Backdrop(
              currentCategory: _currentCategory,
              frontLayer: HomeScreen(category: _currentCategory),
              backLayer: MenuScreen(
                currentCategory: _currentCategory,
                onCategoryTap: _onCategoryTap, 
                onMenuTap: _onMenuTap,
              ),
              frontTitle: _frontTitle,
              backTitle: const Text('Menu'),              
            ),
      },
      theme: AppTheme().buildAppTheme(),
    );
  }
  
  //TODO: Alterar nome do método
  void _onCategoryTap(Category category) {
    setState(() => _currentCategory = category
    );
  }

    void _onMenuTap(Widget frontTitle) {
    setState(() {
      _frontTitle = frontTitle;
    });
  }        
}