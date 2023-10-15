import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_trainer/data/user_dao.dart';
import 'package:personal_trainer/data/user_model.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

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

class DadosPessoais {
  String nome = '';
  String dataNascimento = '';
  String genero = '';
  String telefone = '';
  String email = '';
  String senha = '';
}

class TextFormFieldDemoState extends State<TextFormFieldDemo> {

  DadosPessoais dadosPessoais = DadosPessoais();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _btnSalvar() async {
    final form = _formKey.currentState!;
    
    if (form.validate()) {

      form.save();

      // Crie uma instância de User com os dados do formulário.
      final user = UserModel(
        name: dadosPessoais.nome,
        birthDate: DateTime.tryParse(dadosPessoais.dataNascimento) ?? DateTime.now(),
        gender: dadosPessoais.genero,
        phone: dadosPessoais.telefone,
        email: dadosPessoais.email,
      );
      
      try {

        final userDao = UserDao();
        userDao.insertUser(user);  
        showInSnackBar('Usuário salvo com sucesso');
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
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.person),
                  hintText: 'Qual seu nome completo?',
                  labelText: 'Nome completo'
                ),
                onSaved: (value) {
                  dadosPessoais.nome = value.toString();
                },                
              ),
              sizedBoxSpace,
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.calendar_month),
                  hintText: 'Qual sua data de nascimento?',
                  labelText: 'Data de nascimento'
                ),
                keyboardType: TextInputType.datetime,
                onSaved: (value) {
                  dadosPessoais.dataNascimento = value.toString();
                },
              ),
              sizedBoxSpace,
              TextFormField(
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.accessibility),
                  hintText: 'Qual seu gênero?',
                  labelText: 'Gênero'
                ),
                onSaved: (value) {
                  dadosPessoais.genero = value.toString();
                },                
              ),
              sizedBoxSpace,
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.phone),
                  hintText: 'Qual seu telefone pessoal?',
                  labelText: 'Telefone'
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  dadosPessoais.telefone = value.toString();
                },
                maxLength: 9,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              sizedBoxSpace,
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.email),
                  hintText: 'Qual seu e-mail pessoal?',
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  dadosPessoais.email = value.toString();
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
}
