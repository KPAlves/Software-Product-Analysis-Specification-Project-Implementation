import 'package:flutter/material.dart';
import 'package:personal_trainer/screens/exercise_screen.dart';
import 'package:personal_trainer/screens/home_screen.dart';
import 'package:personal_trainer/theme/colors.dart';

final _emailController = TextEditingController();
final _passwordController = TextEditingController();

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: const [
            SizedBox(height: 60.0),
            _PersonalTrainerLogo(),
            SizedBox(height: 100.0),
            _EmailTextField(),
            SizedBox(height: 12.0),
            _PasswordTextField(),
            SizedBox(height: 12.0),            
            _CancelAndNextButtons(),            
          ],
        ),
      ),
    );
  }
}

class _PersonalTrainerLogo extends StatelessWidget {
  const _PersonalTrainerLogo();

  @override
  Widget build(BuildContext context) {
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
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField();

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: _emailController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField();

  @override
  Widget build(BuildContext context) {


    return TextField(
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Senha",
      ),
    );
  }
}

class _CancelAndNextButtons extends StatelessWidget {
  const _CancelAndNextButtons();

  @override
  Widget build(BuildContext context) {

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
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          child: const Text('ENTRAR'),
        ),
      ],
    );
  }
}
