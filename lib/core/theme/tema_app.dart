import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Identidade visual do app: uma cor de marca (índigo) deliberadamente
/// distinta das cores categóricas de entrada/saída do gráfico, para não
/// misturar "cor de marca" com "cor de dado" — botões e AppBar usam a cor
/// de marca, o gráfico e a lista de faturas usam entrada/saída.
class TemaApp {
  TemaApp._();

  static const Color _marcaClaro = Color(0xFF4F46E5);
  static const Color _marcaEscuro = Color(0xFF818CF8);

  static const Color corEntradaClaro = Color(0xFF2A78D6);
  static const Color corEntradaEscuro = Color(0xFF3987E5);
  static const Color corSaidaClaro = Color(0xFF1BAF7A);
  static const Color corSaidaEscuro = Color(0xFF199E70);

  static const double larguraMaximaConteudo = 480;
  static const double raioPadrao = 16;

  static ThemeData get claro => _construir(
    ColorScheme.fromSeed(seedColor: _marcaClaro, brightness: Brightness.light),
  );

  static ThemeData get escuro => _construir(
    ColorScheme.fromSeed(seedColor: _marcaEscuro, brightness: Brightness.dark),
  );

  static ThemeData _construir(ColorScheme cores) {
    final textoBase = GoogleFonts.interTextTheme(
      ThemeData(brightness: cores.brightness).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: cores.brightness,
      colorScheme: cores,
      scaffoldBackgroundColor: cores.surface,
      textTheme: textoBase,
      appBarTheme: AppBarTheme(
        backgroundColor: cores.surface,
        foregroundColor: cores.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: cores.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cores.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(raioPadrao),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cores.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cores.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cores.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: cores.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cores.primary,
        foregroundColor: cores.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: DividerThemeData(color: cores.outlineVariant, space: 32),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
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
