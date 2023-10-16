import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String databaseName = 'personal_trainer.db'; // Nome do banco de dados
  static const String usersTable = 'users'; // Nome da tabela de usuários

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

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

  // Método chamado durante a criação do banco de dados para criar a tabela de usuários.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $usersTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        birthDate TEXT,
        gender TEXT,
        phone TEXT,
        email TEXT
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
}