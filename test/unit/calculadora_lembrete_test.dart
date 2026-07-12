import 'package:controle_de_faturas/core/notifications/calculadora_lembrete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculadoraLembrete', () {
    const diaVencimento = 20;

    test('dia D-3 dispara "faltam 3 dias"', () {
      final resultado = CalculadoraLembrete.calcular(
        diaVencimento: diaVencimento,
        hoje: DateTime(2026, 7, 17),
      );
      expect(resultado, TipoLembreteVencimento.faltamTresDias);
    });

    test('dia D-2 dispara "último dia é amanhã"', () {
      final resultado = CalculadoraLembrete.calcular(
        diaVencimento: diaVencimento,
        hoje: DateTime(2026, 7, 18),
      );
      expect(resultado, TipoLembreteVencimento.ultimoDiaAmanha);
    });

    test('dia D-1 dispara "último dia é hoje"', () {
      final resultado = CalculadoraLembrete.calcular(
        diaVencimento: diaVencimento,
        hoje: DateTime(2026, 7, 19),
      );
      expect(resultado, TipoLembreteVencimento.ultimoDiaHoje);
    });

    test('dia de vencimento em si não dispara nenhum lembrete', () {
      final resultado = CalculadoraLembrete.calcular(
        diaVencimento: diaVencimento,
        hoje: DateTime(2026, 7, 20),
      );
      expect(resultado, isNull);
    });

    test('dias fora da janela não disparam nenhum lembrete', () {
      final resultado = CalculadoraLembrete.calcular(
        diaVencimento: diaVencimento,
        hoje: DateTime(2026, 7, 1),
      );
      expect(resultado, isNull);
    });

    test('funciona no limite mínimo permitido (dia de vencimento 4)', () {
      expect(
        CalculadoraLembrete.calcular(
          diaVencimento: 4,
          hoje: DateTime(2026, 7, 1),
        ),
        TipoLembreteVencimento.faltamTresDias,
      );
      expect(
        CalculadoraLembrete.calcular(
          diaVencimento: 4,
          hoje: DateTime(2026, 7, 3),
        ),
        TipoLembreteVencimento.ultimoDiaHoje,
      );
    });
  });
}
