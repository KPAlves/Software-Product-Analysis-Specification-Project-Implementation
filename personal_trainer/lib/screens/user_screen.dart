import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_trainer/data/database_helper.dart';
import 'package:personal_trainer/data/user_dao.dart';
import 'package:personal_trainer/data/user_model.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          title: const Text('Cadastro de Usuário'),
        ),
        body: const TextFormFieldDemo(),
    );
  }
}

class TextFormFieldDemo extends StatefulWidget {
  const TextFormFieldDemo({super.key});

  @override
  TextFormFieldDemoState createState() => TextFormFieldDemoState();
}

class TextFormFieldDemoState extends State<TextFormFieldDemo> {
  
  TextEditingController name = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  UserModel user = UserModel(name: '', birthDate: DateTime.now(), gender: '', phone: '', email: '');

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    
    return Form(
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
                  icon: Icon(Icons.person),
                  hintText: 'Qual seu nome completo?',
                  labelText: 'Nome completo'
                ),
                onSaved: (value) {
                  user.name = value.toString();
                },                
              ),
              sizedBoxSpace,
              TextFormField(
                controller: birthDate,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.calendar_month),
                  hintText: 'Qual sua data de nascimento?',
                  labelText: 'Data de nascimento'
                ),
                keyboardType: TextInputType.datetime,
                onSaved: (value) {
                  user.birthDate = DateTime.tryParse(value!) ?? DateTime.now();
                },
              ),
              sizedBoxSpace,
              TextFormField(
                controller: gender,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.accessibility),
                  hintText: 'Qual seu gênero?',
                  labelText: 'Gênero'
                ),
                onSaved: (value) {
                  user.gender = value.toString();
                },                
              ),
              sizedBoxSpace,
              TextFormField(
                controller: phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.phone),
                  hintText: 'Qual seu telefone pessoal?',
                  labelText: 'Telefone'
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  user.phone = value.toString();
                },
                maxLength: 9,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              sizedBoxSpace,
              TextFormField(
                controller: email,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.email),
                  hintText: 'Qual seu e-mail pessoal?',
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  user.email = value.toString();
                },
              ),
              sizedBoxSpace,
              Center(
                child: ElevatedButton(
                  onPressed: _btnSalvar,
                  child: const Text('SALVAR'),
                ),
              ),
              sizedBoxSpace,

            ],
          ),
        ),
      ),
    );
  }

  void _btnSalvar() async {
    final form = _formKey.currentState!;
    
    if (form.validate()) {
      form.save();
      try {
        final userDao = UserDao();
        userDao.insertUser(user);
        //Select na tabela Users exibindo on console
        DatabaseHelper.instance.selectTabelaUsers();
        showInSnackBar('Usuário salvo com sucesso');
        _limparCampos();
      } catch (e) {
        showInSnackBar('Erro ao salvar o usuário');      
      }
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  void _limparCampos() {
    setState(() {
      name.clear();
      birthDate.clear();
      gender.clear();
      phone.clear();
      email.clear();
  });
}
}


