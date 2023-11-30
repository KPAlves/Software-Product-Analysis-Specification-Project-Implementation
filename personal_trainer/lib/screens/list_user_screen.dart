import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_trainer/data/user_dao.dart';
import 'package:personal_trainer/data/user_model.dart';
import 'package:personal_trainer/screens/user_screen.dart';

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({super.key});

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {

  final userDao = UserDao();
  final userStreamController = StreamController<List<UserModel>>.broadcast();

    @override
  void initState() {
    super.initState();
    // Inicializa o Stream com a lista de usuários do banco de dados.
    userDao.getUsers().then((users) {
      userStreamController.sink.add(users);
    });
  }

  @override
  void dispose() {
    userStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const UserScreen()),
          ).then((result) {
              // Quando um usuário é adicionado, recarregue a lista de usuários.
              userDao.getUsers().then((users) {
                userStreamController.sink.add(users);
              });
            }
          );
        },
        child: const Icon(Icons.add),
      ),
      body:StreamBuilder<List<UserModel>>(
        stream: userStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data;
            return ListView.builder(
              itemCount: users?.length,
              itemBuilder: (context, index) {
                final user = users?[index];
                return ListTile(
                  title: Text(user!.name),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => {},//_openDialogBox(exerciseID: exerciseID),
                        icon: const Icon(Icons.edit)
                      ),
                      IconButton(
                        onPressed: () => {},//_excluirExercicio(exerciseID: exerciseID),
                        icon: const Icon(Icons.delete)
                      ),                                      
                    ],
                  ),                  
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

