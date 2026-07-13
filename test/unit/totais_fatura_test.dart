import 'package:controle_de_faturas/features/faturas/application/totais_fatura_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TotaisFatura', () {
    test('iva é 10% da diferença quando há lucro', () {
      const totais = TotaisFatura(entrada: 6000000, saida: 380000);
      expect(totais.diferenca, 5620000);
      expect(totais.iva, 562000);
    });

    test('iva é zero quando a diferença é negativa', () {
      const totais = TotaisFatura(entrada: 100000, saida: 500000);
      expect(totais.diferenca, -400000);
      expect(totais.iva, 0);
    });

    test('iva é zero quando entrada e saída são iguais', () {
      const totais = TotaisFatura(entrada: 200000, saida: 200000);
      expect(totais.iva, 0);
    });

    test('iva arredonda para o inteiro mais próximo', () {
      const totais = TotaisFatura(entrada: 105, saida: 0);
      expect(totais.iva, 11);
    });
  });
}
