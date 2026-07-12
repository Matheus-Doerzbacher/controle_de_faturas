import 'package:flutter/material.dart';

/// Tema do app e cores categóricas fixas de entrada/saída.
///
/// Entrada e saída são tratadas como identidade categórica, não como
/// "bom/ruim" — mais saída (mais faturas de gasto) é justamente o que o
/// usuário quer para aproximar os dois valores, então não usamos a
/// convenção intuitiva verde=bom/vermelho=ruim.
class TemaApp {
  TemaApp._();

  static const Color corEntradaClaro = Color(0xFF2A78D6);
  static const Color corEntradaEscuro = Color(0xFF3987E5);
  static const Color corSaidaClaro = Color(0xFF1BAF7A);
  static const Color corSaidaEscuro = Color(0xFF199E70);

  static const double larguraMaximaConteudo = 480;

  static ThemeData get claro => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: corEntradaClaro),
  );

  static ThemeData get escuro => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: corEntradaEscuro,
      brightness: Brightness.dark,
    ),
  );
}

/// Acesso ergonômico às cores de entrada/saída a partir de qualquer
/// `BuildContext`, já resolvidas para o brightness atual (claro/escuro).
extension CoresFaturaContexto on BuildContext {
  Color get corEntrada => Theme.of(this).brightness == Brightness.dark
      ? TemaApp.corEntradaEscuro
      : TemaApp.corEntradaClaro;

  Color get corSaida => Theme.of(this).brightness == Brightness.dark
      ? TemaApp.corSaidaEscuro
      : TemaApp.corSaidaClaro;
}
