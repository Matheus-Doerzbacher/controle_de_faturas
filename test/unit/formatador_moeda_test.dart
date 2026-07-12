import 'package:controle_de_faturas/core/utils/formatador_moeda.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormatadorMoeda', () {
    test('formata valores pequenos sem separador', () {
      expect(FormatadorMoeda.formatar(500), '₲ 500');
    });

    test('formata milhares com ponto separador', () {
      expect(FormatadorMoeda.formatar(150000), '₲ 150.000');
    });

    test('formata milhões com múltiplos separadores', () {
      expect(FormatadorMoeda.formatar(12345678), '₲ 12.345.678');
    });

    test('formata zero', () {
      expect(FormatadorMoeda.formatar(0), '₲ 0');
    });

    test('formata valores negativos', () {
      expect(FormatadorMoeda.formatar(-15000), '-₲ 15.000');
    });
  });
}
