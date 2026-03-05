import 'package:flutter/material.dart';

/// Temas claro e escuro com paleta adaptada ao sistema.
abstract class AppTheme {
  /// Tema claro.
  static final claro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A9D8F)),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
  );

  /// Tema escuro.
  static final escuro = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2A9D8F),
      brightness: Brightness.dark,
    ),
  );
}
