import 'package:flutter/material.dart';

class AppTheme {
  static const Color primario = Color(0xFF0F5796);
  static const Color fondo = Color(0xFFF3F5F8);
  static const Color barraInferior = Color(0xFF082647);

  static const Color verdeOperativo = Color(0xFF2E9E49);
  static const Color verdeFondo = Color(0xFFEAF8EE);
  static const Color rojoFalla = Color(0xFFDE3737);
  static const Color rojoFondo = Color(0xFFFDECEC);

  static const Color textoTitulo = Color(0xFF0F3256);
  static const Color textoSecundario = Color(0xFF6C757D);

  static ThemeData get tema {
    return ThemeData(
      scaffoldBackgroundColor: fondo,
      primaryColor: primario,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textoTitulo),
        titleTextStyle: TextStyle(
          color: textoTitulo,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}