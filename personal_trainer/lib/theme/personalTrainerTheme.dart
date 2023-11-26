import 'package:flutter/material.dart';
import 'package:personal_trainer/theme/colors.dart';
import 'package:personal_trainer/theme/cut_corners_border.dart';

class PersonalTrainerTheme {

    buildPersonalTrainerTheme() {
    final ThemeData base = ThemeData.light(useMaterial3: true);
    
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: pink100,
        onPrimary: brown900,
        secondary: brown900,
        error: errorRed,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: pink100,
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: brown900,
        backgroundColor: pink100,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: CutCornersBorder(),
        focusedBorder: CutCornersBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: brown900,
          ),
        ),
        floatingLabelStyle: TextStyle(
          color: brown900,
        ),
      ),
    );
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base
        .copyWith(
          headlineSmall: base.headlineSmall!.copyWith(
            fontWeight: FontWeight.w500,
          ),
          titleLarge: base.titleLarge!.copyWith(
            fontSize: 18.0,
          ),
          bodySmall: base.bodySmall!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
          bodyLarge: base.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        )
        .apply(
          fontFamily: 'Rubik',
          displayColor: brown900,
          bodyColor: brown900,
        );
  }
}