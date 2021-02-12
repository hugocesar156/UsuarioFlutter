import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfilusuario_app/usuario.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Home> {
  String nomeEdicao = '';
  String nomeSalvo = '';
  List<Usuario> lista = [];
  TextEditingController nome = TextEditingController(text: nomeEdicao ?? nomeSalvo);

  editarUsuario(Usuario usuario) async {
    usuario.nome = nome.text;
    await Usuario().atualizar(usuario);
    nome.text = '';

    var novaLista = await listarUsuario();
    setState(() {
      lista = novaLista;
    });
  }

  listarUsuario() async => lista = await Usuario().listar();

  removerUsuario(String idUsuario) async {
    await Usuario().remover(idUsuario);

    var novaLista = await listarUsuario();
    setState(() {
      lista = novaLista;
    });
  }

  salvarUsuario() async {
    await Usuario().salvar(Usuario(nome: nome.text));
    nome.text = '';

    var novaLista = await listarUsuario();
    setState(() {
      lista = novaLista;
    });
  }

  @override
  Widget build(BuildContext context) {
    listarUsuario();

    return Scaffold(
      appBar: AppBar(title: Text('Lista de usuários'), backgroundColor: Colors.blue),
      body: ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, i){
            print('lista carregada: ${lista.toString()}');
            return Column(
              children: [
                Card(
                  child: Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key(lista[i].idUsuario),
                    child: ListTile(
                      title: Text(lista[i].nome),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text('Editar usuário'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: nome,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                                labelText: 'Nome',
                                                hintText: 'nome de usuário'
                                            ),
                                          ),],
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text('Cancelar')
                                        ),
                                        FlatButton(
                                            onPressed: (){
                                              editarUsuario(lista[i]);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Salvar')
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text('Remover usuário?'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text('Cancelar')
                                        ),
                                        FlatButton(
                                            onPressed: (){
                                              removerUsuario(lista[i].idUsuario.toString());
                                              Navigator.pop(context);
                                            },
                                            child: Text('Remover')
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('Novo usuário'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nome,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        hintText: 'nome de usuário'
                      ),
                    ),],
                ),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar')
                  ),
                  FlatButton(
                      onPressed: (){
                        salvarUsuario();
                        Navigator.pop(context);
                      },
                      child: Text('Salvar')
                  ),
                ],
              );
            }
          );
        },
      ),
    );
  }
}