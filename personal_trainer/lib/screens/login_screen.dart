import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          restorationId: 'login_list_view',
          children: const [
            SizedBox(height: 80),
            _PersonalLogo(),
            SizedBox(height: 120),
            _UserNameTextField(),
            SizedBox(height: 12),
            _NextButton(),
          ],
        ),
      ),
    );
  }
}

class _PersonalLogo extends StatelessWidget{
  const _PersonalLogo();
  
  @override
  Widget build(BuildContext context) {
        return ExcludeSemantics(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Personal Trainer',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class _UserNameTextField extends StatelessWidget{
  const _UserNameTextField();
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      textInputAction: TextInputAction.next,
      restorationId: 'username_text_field',
      cursorColor: colorScheme.onSurface,
      decoration: const InputDecoration(
        labelText: 'UserName',
        labelStyle: TextStyle(
          letterSpacing: 0.04,
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget{
  const _NextButton();
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const buttonTextPadding = EdgeInsets.zero;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: OverflowBar(
        spacing: 8,
        alignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),
            onPressed: () {
              // The login screen is immediately displayed on top of
              // the Shrine home screen using onGenerateRoute and so
              // rootNavigator must be set to true in order to get out
              // of Shrine completely.
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Padding(
              padding: buttonTextPadding,
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 8,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),
            onPressed: () {
              Navigator.of(context).restorablePushNamed('');
            },
            child: const Padding(
              padding: buttonTextPadding,
              child: Text(
                'Next',
                style: TextStyle(
                    letterSpacing: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}