import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_trainer/data/user_dao.dart';
import 'package:personal_trainer/data/user_model.dart';
import 'package:personal_trainer/screens/add_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
      appBar: AppBar(title: const Text('Lista de Usuários')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddUserScreen()),
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

