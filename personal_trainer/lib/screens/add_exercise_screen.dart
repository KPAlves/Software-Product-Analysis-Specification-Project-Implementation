import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_trainer/data/database_helper.dart';
import 'package:personal_trainer/data/exercise_dao.dart';
import 'package:personal_trainer/data/exercise_model.dart';



List<String> _list = <String>['abdominal', 'esteira', 'flexao', 'isometria', 'supino_inclinado', 'supino_reto', 'supino_reto_maquina', 'triceps_banco_sentado', 'triceps_banco', 'triceps_martelo_deitado', 'triceps_mergulho', 'triceps_polia'];


class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController image = TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ExerciseModel exercise = ExerciseModel(name: '', description: '', image: '');

  final exerciseDao = ExerciseDao();
  final exerciseStreamController = StreamController<List<ExerciseModel>>.broadcast();
  
  @override
  void initState() {
    super.initState();
    // Inicializa o Stream com a lista de usuários do banco de dados.
    exerciseDao.getExercises().then((exercises) {
      exerciseStreamController.sink.add(exercises);
    });
  }

  @override
  void dispose() {
    exerciseStreamController.close();
    super.dispose();
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }

  String dropdownValue = "";

  void openDialogBox() {
    const sizedBoxSpace = SizedBox(height: 24);
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: Form(
          key: _formKey,
          child: Scrollbar(
            child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  sizedBoxSpace,
                  TextFormField(
                    controller: name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      filled: true,
                      icon: Icon(Icons.sports_gymnastics),
                      hintText: 'Nome do exercício',
                      labelText: 'Exercício*'
                    ),
                    onSaved: (value) {
                      exercise.name = value.toString();
                    },
                    validator: _validateField,                
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    controller: description,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      filled: true,
                      icon: Icon(Icons.description),
                      hintText: 'Descrição do exercício',
                      labelText: 'Descrição*'
                    ),
                    onSaved: (value) {
                      exercise.description = value.toString();
                    },
                    validator: _validateField, 
                  ),
                  sizedBoxSpace,
                  DropdownMenu<String>(
                    width: 220,
                    controller: image,
                    leadingIcon: const Icon(Icons.image),
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                    ),
                    hintText: "Imagem*",
                    onSelected: (value) {
                      setState(() {
                        dropdownValue = value!;
                        exercise.image = 'assets/images/$value.png';
                      });
                    },
                    dropdownMenuEntries: _list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(), 
                  ),              
                ],
              ),
            ),
          ),
        ) ,
        actions: [
          ElevatedButton(
            onPressed: () {
              _limparCampos();          
              Navigator.pop(context);
           }, 
           child: const Text('Voltar'),
          ),            
          ElevatedButton(
            onPressed: () {
              _btnSalvar();
              _atualizarListaExercicios();
            }, 
            child: const Text('Salvar'),
          ),     
        ],
      ),
    );
  }

  void _atualizarListaExercicios() {
    exerciseDao.getExercises().then((exercises) {
      exerciseStreamController.sink.add(exercises);
    });  
  }

  void _limparCampos() {
    setState(() {
      name.clear();
      description.clear();
      image.clear();
    }); 
  }

  void _btnSalvar() async {
    final form = _formKey.currentState!;
    
    if (form.validate()) {
      form.save();
      try {
        final exerciseDao = ExerciseDao();
        exerciseDao.insertExercise(exercise);
        //Select na tabela Users exibindo on console
        DatabaseHelper.instance.selectTabelaExercises();
        showInSnackBar('Exercício salvo com sucesso');
        _limparCampos();
      } catch (e) {
        showInSnackBar('Erro ao salvar exercício');      
      }
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exercícios'),
            // Text(
                //   'Subtitulo App Bar',
                //   style: Theme.of(context)
                //       .textTheme
                //       .titleSmall!
                //       .copyWith(color: Colors.white),
                // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openDialogBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<ExerciseModel>>(
        stream: exerciseStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final exercises = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsetsDirectional.only(start: 8.0),
                  child: Text('Lista de Exercícios'),    
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: exercises?.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises?[index];
                      return Row(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              child: Image.asset(
                                exercise!.image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24,),
                          Expanded(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(exercise.name),
                                  subtitle: Text(exercise.description),
                                  trailing: Text('0${index + 1}'),
                                ),
                                const Divider(thickness: 2),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );           
          } else {
            return const Text("Nenuhm exercício...");
          }
        },
      ),
    );
  }
}
