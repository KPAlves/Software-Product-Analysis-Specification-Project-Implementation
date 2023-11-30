import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_trainer/data/database_helper.dart';
import 'package:personal_trainer/data/exercise_dao.dart';
import 'package:personal_trainer/data/exercise_model.dart';
import 'package:personal_trainer/theme/colors.dart';


List<String> _list = <String>['abdominal', 'esteira', 'flexao', 'isometria', 'supino_inclinado', 'supino_reto', 'supino_reto_maquina', 'triceps_banco_sentado', 'triceps_banco', 'triceps_martelo_deitado', 'triceps_mergulho', 'triceps_polia'];

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});
  
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  
  
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

  String selectedValue = '';

  void _openDialogBox({int? exerciseID}) {
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
                    controller: name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
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
                  DropdownButtonFormField<String>(
                    isExpanded: true,          
                    validator: _validateField,            
                    decoration: const InputDecoration(
                      hintText: 'Imagem*',
                      icon: Icon(Icons.image),                     
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                        exercise.image = 'assets/images/$value.png';
                      });
                    },
                    items: _list.map<DropdownMenuItem<String>>(
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
              
              _btnSalvar(exerciseID);
              _atualizarListaExercicios();
              _limparCampos();
              _formKey.currentState?.reset();
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

  void _btnSalvar(int? exerciseID) async {
    final form = _formKey.currentState!;
    
    if (form.validate()) {
      form.save();
      try {
        final exerciseDao = ExerciseDao();

        if (exerciseID == null) {
          exercise.id = null;
          exerciseDao.insertExercise(exercise);
          //Select na tabela Exercises exibindo on console
          DatabaseHelper.instance.selectTabelaExercises();
          showInSnackBar('Exercício salvo com sucesso');
        } else {
          exercise.id = exerciseID;
          exerciseDao.updateExercise(exercise);
          //Update na tabela Exercises
          DatabaseHelper.instance.selectTabelaExercises();
          showInSnackBar('Exercício atualizado com sucesso');
        }
        // _formKey.currentState?.reset();
      } catch (e) {
        showInSnackBar('Erro ao salvar exercício');      
      }
    }
  }

    void _excluirExercicio({required int exerciseID}) async {
    
      final exerciseDao = ExerciseDao();

      exerciseDao.deleteExercise(exerciseID);
      //Select na tabela Exercises exibindo on console
      DatabaseHelper.instance.selectTabelaExercises();
      _atualizarListaExercicios();
      showInSnackBar('Excluído com sucesso');

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
      floatingActionButton: FloatingActionButton(
        foregroundColor: brown900,
        backgroundColor: pink100,
        elevation: 8.0,
        onPressed: _openDialogBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<ExerciseModel>>(
        stream: exerciseStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final exercises = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(2),
                    itemCount: exercises?.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises![index];
                      int exerciseID = exercise.id!;
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
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(exercise.name),
                                  subtitle: Text(exercise.description),
                                  // trailing: Text('${index + 1}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () => _openDialogBox(exerciseID: exerciseID),
                                        icon: const Icon(Icons.edit)
                                      ),
                                      IconButton(
                                        onPressed: () => _excluirExercicio(exerciseID: exerciseID),
                                        icon: const Icon(Icons.delete)
                                      ),                                      
                                    ],
                                  ),
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
            return const Text("  Nenuhm exercício cadastrado...");
          }
        },
      ),
    );
  }
}
