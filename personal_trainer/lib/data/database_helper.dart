import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String databaseName = 'personal_trainer.db'; // Nome do banco de dados
  static const String usersTable = 'users'; // Nome da tabela de usuários
  static const String exercisesTable = 'exercises'; // Nome da tabela de exercícios
  static const String perfilAcessoTable = 'perfilAcesso'; // Nome da tabela de perfis acesso

  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  late Database _database;

  // Inicializa o banco de dados ou abre a conexão se já estiver criado.
  Future<Database> initializeDatabase() async {

    // Obtém o caminho do banco de dados e cria o banco de dados.
    _database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: _onCreate,
    );

    return _database;
  }

  // Método chamado durante a criação do banco de dados para criar a tabela de usuários e tabela de exercícios.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $usersTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        birthDate TEXT,
        gender TEXT,
        phone TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $exercisesTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        image TEXT
      )
    ''');   
    
    await db.execute('''
      CREATE TABLE $perfilAcessoTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        user TEXT
      )
    ''');        
  }

  // Obtém a instância do banco de dados.
  Future<Database?> get database async {
    
    _database = await initializeDatabase();
    return _database;
  }

  Future<void> selectTabelaUsers() async { 
    
  final db = await initializeDatabase();
    List<Map> list = await db.rawQuery('SELECT * FROM users');
    for (var element in list) {
      print(element);
    }
  }

  Future<void> selectTabelaExercises() async { 
    
    final db = await initializeDatabase();
    List<Map> list = await db.rawQuery('SELECT * FROM exercises');
    for (var element in list) {
      print(element);
    }
  }

  Future<void> selectTabelaPerfilAcesso() async { 
    
    final db = await initializeDatabase();
    List<Map> list = await db.rawQuery('SELECT * FROM perfilAcesso');
    for (var element in list) {
      print(element);
    }
  }

}