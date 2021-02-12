import 'package:perfilusuario_app/databaseInstance.dart';
import 'package:sqflite/sqflite.dart';

class Usuario {
  String idUsuario;
  String nome;
  String cpf;
  String email;
  String telefone;

  Database banco;

  Usuario({
    this.idUsuario,
    this.nome,
    this.cpf,
    this.email,
    this.telefone});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUsuario'] = this.idUsuario;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['email'] = this.email;
    data['telefone'] = this.telefone;
    return data;
  }

  String toString() {
    return "Usuario(idUsuario:$idUsuario, nome:$nome, cpf: $cpf, email: $email, telefone:$telefone)";
  }

  Usuario fromMap(Map map){
    Usuario usuario = Usuario();
    usuario.idUsuario = map['idUsuario'].toString();
    usuario.nome = map['nome'];
    usuario.cpf = map['cpf'];
    usuario.email = map['email'];
    usuario.telefone = map['telefone'];
    return usuario;
  }

  Future<int> atualizar(Usuario usuario) async {
    try{
      banco = await DatabaseInstance().db;

      return await banco.update(
          'usuario', usuario.toJson(),
          where: 'idUsuario = ?',
          whereArgs: [usuario.idUsuario]
      );
    }
    catch(e){
      print('Falha ao atualizar usuário: $e');
      return 0;
    }
  }

  Future<Usuario> buscar(int id) async {
    try{
      banco = await DatabaseInstance().db;
      var mapList = await banco.rawQuery('SELECT * FROM usuario WHERE idUsuario = $id;');

      return fromMap(mapList.first);
    }
    catch (e){
      print('Falha ao buscar usuário: $e');
      return null;
    }
  }

  Future<List<Usuario>> listar() async {
    try {
      banco = await DatabaseInstance().db;
      var mapList = await banco.rawQuery('SELECT * FROM usuario ORDER BY nome');

      List<Usuario> lista = List<Usuario>();

      for(var map in mapList){
        lista.add(fromMap(map));
      }

      return lista;
    }
    catch (e) {
      print('Falha ao listar usuário: $e');
      return null;
    }
  }

  Future<int> remover(String idUsuario) async {
    try {
      banco = await DatabaseInstance().db;
      return await banco.rawDelete('DELETE FROM usuario WHERE idUsuario = ?', [idUsuario]);
    }
    catch (e) {
      print('Falha ao inserir usuário: $e');
      return 0;
    }
  }

  Future<int> salvar(Usuario usuario) async {
    try {
      banco = await DatabaseInstance().db;
      return await banco.insert('usuario', usuario.toJson());
    }
    catch (e) {
      print('Falha ao inserir usuário: $e');
      return 0;
    }
  }
}
