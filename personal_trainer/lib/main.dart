import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: Scaffold(
        appBar: AppBar(
         title: const Text('Cadastro de Usuário'),
        ),
        body: const TextFormFieldDemo(),
      ),
    );
  }
}

class TextFormFieldDemo extends StatefulWidget {
  const TextFormFieldDemo({super.key});

  @override
  TextFormFieldDemoState createState() => TextFormFieldDemoState();
}

class DadosPessoais {
  String? nome = '';
  String? dataNascimento = '';
  String? sexo = '';
  String? telefone = '';
  String? email = '';
  String senha = '';
}

class TextFormFieldDemoState extends State<TextFormFieldDemo> {

  DadosPessoais dadosPessoais = DadosPessoais();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _btnSalvar() {
    final form = _formKey.currentState!;
    
    form.save();
    showInSnackBar('Salvo');

    print('Campo nome: ${dadosPessoais.nome}');
    print('Campo data nascimento: ${dadosPessoais.dataNascimento}');
    print('Campo sexo: ${dadosPessoais.sexo}');
    print('Campo telefone: ${dadosPessoais.telefone}');
    print('Campo email: ${dadosPessoais.email}');
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
                  dadosPessoais.nome = value;
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
                  dadosPessoais.dataNascimento = value;
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
                  labelText: 'Sexo'
                ),
                onSaved: (value) {
                  dadosPessoais.sexo = value;
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
                  dadosPessoais.telefone = value;
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
                  dadosPessoais.email = value;
                },
              ),
              sizedBoxSpace,
              Center(
                child: ElevatedButton(
                  onPressed: _btnSalvar,
                  child: Text('SALVAR'),
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
