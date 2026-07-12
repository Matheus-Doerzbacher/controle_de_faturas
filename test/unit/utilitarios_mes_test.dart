import 'package:controle_de_faturas/core/utils/utilitarios_mes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('UtilitariosMes', () {
    test('normaliza para o dia 1, sem hora', () {
      final normalizado = UtilitariosMes.normalizar(
        DateTime(2026, 7, 17, 14, 30),
      );
      expect(normalizado, DateTime(2026, 7, 1));
    });

    test('mesAnterior cruza o ano corretamente (janeiro -> dezembro)', () {
      final anterior = UtilitariosMes.mesAnterior(DateTime(2026, 1, 1));
      expect(anterior, DateTime(2025, 12, 1));
    });

    test('proximoMes cruza o ano corretamente (dezembro -> janeiro)', () {
      final proximo = UtilitariosMes.proximoMes(DateTime(2026, 12, 1));
      expect(proximo, DateTime(2027, 1, 1));
    });

    test('ultimoDia cobre corretamente um ano bissexto (fevereiro)', () {
      expect(UtilitariosMes.ultimoDia(DateTime(2024, 2, 1)).day, 29);
    });

    test('ultimoDia cobre corretamente um ano não bissexto (fevereiro)', () {
      expect(UtilitariosMes.ultimoDia(DateTime(2026, 2, 1)).day, 28);
    });

    test('ultimoDia cobre corretamente um mês de 31 dias', () {
      expect(UtilitariosMes.ultimoDia(DateTime(2026, 7, 1)).day, 31);
    });

    test('formatarDataIso usa yyyy-MM-dd com zero à esquerda', () {
      expect(
        UtilitariosMes.formatarDataIso(DateTime(2026, 1, 5)),
        '2026-01-05',
      );
    });

    test('rotulo capitaliza o nome do mês em português', () {
      expect(
        UtilitariosMes.rotulo(DateTime(2026, 7, 1), 'pt'),
        'Julho de 2026',
      );
    });

    test('rotulo capitaliza o nome do mês em espanhol', () {
      expect(
        UtilitariosMes.rotulo(DateTime(2026, 7, 1), 'es'),
        'Julio de 2026',
      );
    });
  });
}
