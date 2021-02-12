import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseInstance {
  static final _databaseInstance = DatabaseInstance._internal();
  Database _db;

  factory DatabaseInstance() => _databaseInstance;

  DatabaseInstance._internal();

   Future<Database> get db async{
    if (_db == null){
      final caminhoBancoDados = await getDatabasesPath();
      final localBancoDados = join(caminhoBancoDados, "rastreamento.db");

      _db = await openDatabase(localBancoDados, version: 1);

      _db.execute(
          'CREATE TABLE IF NOT EXISTS usuario (idUsuario INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nome VARCHAR, cpf VARCHAR, email VARCHAR, telefone VARCHAR);'
      );
    }

    return _db;
  }
}