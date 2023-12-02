import 'dart:async';
import 'package:personal_trainer/data/database_helper.dart';
import 'package:personal_trainer/data/perfil_acesso_dao.dart';

import 'package:flutter/material.dart';
import 'package:personal_trainer/data/perfil_acesso_model.dart';
import 'package:personal_trainer/data/user_dao.dart';
import 'package:personal_trainer/data/user_model.dart';
import 'package:personal_trainer/theme/colors.dart';

class PerfilAcessoScreen extends StatefulWidget {
  const PerfilAcessoScreen({super.key});

  @override
  State<PerfilAcessoScreen> createState() => _PerfilAcessoScreenState();
}

class _PerfilAcessoScreenState extends State<PerfilAcessoScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController image = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PerfilAcessoModel perfilAcesso = PerfilAcessoModel(name: '', description: '', user: '');


  final userDao = UserDao();
  final perfilAcessoDao = PerfilAcessoDao();
  final perfilAcessoStreamController = StreamController<List<PerfilAcessoModel>>.broadcast();  
  
  List<String> _users = [];

  void carregaUsers() async {

    List<Map<String, dynamic>> userListData = await userDao.getListUsers();

    List<UserModel> userList = userListData.map((userData) => UserModel.fromMap(userData)).toList();

    _users = userList.map((user) => user.name).toList();

    // Imprimindo a lista de nomes
    print(_users);
  }


  @override
  void initState() {
    super.initState();
    // Inicializa o Stream com a lista de perfis do banco de dados.
    perfilAcessoDao.getPerfilAcesso().then((perfis) {
      perfilAcessoStreamController.sink.add(perfis);
    });
    carregaUsers();
  }

  @override
  void dispose() {
    perfilAcessoStreamController.close();
    super.dispose();
  }

  void _limparCampos() {
    setState(() {
      nameController.clear();
      descriptionController.clear();
      image.clear();
    }); 
  }

  void _btnSalvar(int? perfilAcessoID) async {
    final form = _formKey.currentState!;
    
    if (form.validate()) {
      form.save();
      try {
        final perfilAcessoDao = PerfilAcessoDao();

        if (perfilAcessoID == null) {
          perfilAcesso.id = null;
          perfilAcessoDao.insertPerfilAcesso(perfilAcesso);
          //Select na tabela Perfil Acesso exibindo on console
          DatabaseHelper.instance.selectTabelaPerfilAcesso();
          showInSnackBar('Perfil salvo com sucesso');
        } else {
          perfilAcesso.id = perfilAcessoID;
          perfilAcessoDao.updatePerfilAcesso(perfilAcesso);
          //Update na tabela Perfil Acesso
          DatabaseHelper.instance.selectTabelaPerfilAcesso();
          showInSnackBar('Perfil Acesso atualizado com sucesso');
        }
        // _formKey.currentState?.reset();
      } catch (e) {
        showInSnackBar('Erro ao salvar Perfil Acesso');      
      }
    }
  }

    void _excluirPerfil({required int perfilAcessoID}) async {
    
      final perfilAcessoDao = PerfilAcessoDao();

      perfilAcessoDao.deletePerfilAcesso(perfilAcessoID);
      //Select na tabela Exercises exibindo on console
      DatabaseHelper.instance.selectTabelaExercises();
      _atualizarListaPerfis();
      showInSnackBar('Excluído com sucesso');

  }  

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  String selectedValue = '';
  void _openDialogBox({int? perfilAcessoID}) {
    const sizedBoxSpace = SizedBox(height: 24);
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Form(
          key: _formKey,
          child: Scrollbar(
            child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  sizedBoxSpace,
                  TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Perfil de acesso',
                    ),
                    onSaved: (value) {
                      perfilAcesso.name = value.toString();
                    },
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    controller: descriptionController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.description),
                      hintText: 'Descrição',
                    ),
                    onSaved: (value) {
                      perfilAcesso.description = value.toString();
                    },
                  ),
                  sizedBoxSpace,
                  DropdownButtonFormField<String>(
                    isExpanded: true,          
                    decoration: const InputDecoration(
                      hintText: 'Usuário',
                      icon: Icon(Icons.verified_user),                     
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                        perfilAcesso.user = value.toString();
                      });
                    },
                    items: _users.map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ) ,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: brown900,
              elevation: 8.0,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
            ),                 
            onPressed: () {
              _limparCampos();       
              _formKey.currentState?.reset();   
              Navigator.pop(context);
           }, 
           child: const Text('Voltar'),
          ),            
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: brown900,
              elevation: 8.0,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
            ),            
            onPressed: () {
              
              _btnSalvar(perfilAcessoID);
              _atualizarListaPerfis();
              _limparCampos();
              _formKey.currentState!.reset();
            }, 
            child: const Text('Salvar'),
          ),     
        ],
      ),
    );
  }

  void _atualizarListaPerfis() {
    perfilAcessoDao.getPerfilAcesso().then((perfis) {
      perfilAcessoStreamController.sink.add(perfis);
    });  
  }  

  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: brown900,
        backgroundColor: pink100,
        elevation: 8.0,
        onPressed: _openDialogBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<PerfilAcessoModel>>(
        stream: perfilAcessoStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final perfis = snapshot.data!;
            return ListView.builder(
                    padding: const EdgeInsets.all(2),
                    itemCount: perfis.length,
                    itemBuilder: (context, index) {
                      final perfil = perfis[index];
                      int perfilID = perfil.id!;
                      return ListTile(
                                  title: Text(perfil.name),
                                  subtitle: Text(perfil.description),
                                  // trailing: Text('${index + 1}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () => _openDialogBox(perfilAcessoID: perfilID),
                                        icon: const Icon(Icons.edit)
                                      ),
                                      IconButton(
                                        onPressed: () => _excluirPerfil(perfilAcessoID: perfilID),
                                        icon: const Icon(Icons.delete)
                                      ),                                      
                          ],
                        ),
                      );
                    },
                  );         
          } else {
            return const Text("  Nenuhm perfil acesso cadastrado...");
          }
        },
      ),
    );
  }
}