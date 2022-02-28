import 'package:flutter/material.dart';
import 'package:misty_tracer/theme/colors.dart';

ThemeData buildTheme(bool darkMode) {
  final base = darkMode ? ThemeData.dark() : ThemeData.light();

  return darkMode
      ? base.copyWith(
          primaryColor: darkScheme.primary,
          colorScheme: darkScheme,
          checkboxTheme: base.checkboxTheme.copyWith(
            fillColor: MaterialStateProperty.all(darkScheme.primary),
          ),
        )
      : base.copyWith(
          primaryColor: lightScheme.primary,
          colorScheme: lightScheme,
          checkboxTheme: base.checkboxTheme.copyWith(
            fillColor: MaterialStateProperty.all(lightScheme.primary),
          ),
        );
}
