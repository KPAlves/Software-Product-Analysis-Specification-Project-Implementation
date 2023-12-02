import 'package:flutter/material.dart';
import 'package:personal_trainer/theme/colors.dart';

final _emailController = TextEditingController();
final _passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            const SizedBox(height: 60.0),
            _personaltrainerlogo(),
            const SizedBox(height: 100.0),
            _emailTextField(),
            const SizedBox(height: 12.0),
            _passwordTextField(),
            const SizedBox(height: 12.0),            
            _cancelAndNextButtons(),            
          ],
        ),
      ),
    );
  }

  Widget _personaltrainerlogo() {
 
    return Column(
      children: [
        Image.asset('assets/images/logo_min.png'),
        const SizedBox(height: 16),
        Text(
          'PERSONAL TRAINER',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }

  Widget _emailTextField() {

    return TextField(
      controller: _emailController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
    );
  }

  Widget _passwordTextField() {

    return TextField(
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Senha",
      ),
    );
  }

  Widget _cancelAndNextButtons() {
    return OverflowBar(
      alignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: brown900,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
          ),
          onPressed: () {
            _emailController.clear();
            _passwordController.clear();
          },
          child: const Text('CANCELAR'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: brown900,
            backgroundColor: pink100,
            elevation: 8.0,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('ENTRAR'),
        ),
      ],
    );
  } 
}