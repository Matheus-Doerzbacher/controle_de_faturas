import 'package:controle_de_faturas/core/utils/formatador_moeda.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormatadorMoeda', () {
    test('formata valores pequenos sem separador', () {
      expect(FormatadorMoeda.formatar(500), 'Gs. 500');
    });

    test('formata milhares com ponto separador', () {
      expect(FormatadorMoeda.formatar(150000), 'Gs. 150.000');
    });

    test('formata milhões com múltiplos separadores', () {
      expect(FormatadorMoeda.formatar(12345678), 'Gs. 12.345.678');
    });

    test('formata zero', () {
      expect(FormatadorMoeda.formatar(0), 'Gs. 0');
    });

    test('formata valores negativos', () {
      expect(FormatadorMoeda.formatar(-15000), '-Gs. 15.000');
    });
  });

  group('MascaraValorGuarani', () {
    final mascara = MascaraValorGuarani();

    TextEditingValue digitar(String texto) {
      return mascara.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: texto),
      );
    }

    test('insere pontos de milhar enquanto digita', () {
      expect(digitar('150000').text, '150.000');
    });

    test('cursor sempre vai para o fim do texto formatado', () {
      final resultado = digitar('150000');
      expect(resultado.selection.baseOffset, resultado.text.length);
    });

    test('remove caracteres que não são dígitos', () {
      expect(digitar('1a5b0').text, '150');
    });

    test('texto vazio permanece vazio', () {
      expect(digitar('').text, '');
    });
  });
}
