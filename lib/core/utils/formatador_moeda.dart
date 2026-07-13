import 'package:flutter/services.dart';

/// Formata valores em Guarani, sem casas decimais e com ponto como
/// separador de milhar (ex: "Gs. 150.000") — não depende de dados de locale
/// do `intl`, então funciona de forma determinística em qualquer plataforma.
class FormatadorMoeda {
  FormatadorMoeda._();

  static String formatar(int valor) {
    final sinal = valor < 0 ? '-' : '';
    return '${sinal}Gs. ${agruparMilhares(valor.abs().toString())}';
  }

  /// Insere pontos de milhar numa sequência de dígitos (ex: "150000" ->
  /// "150.000"). Reaproveitado por [formatar] e por [MascaraValorGuarani].
  static String agruparMilhares(String digitos) {
    final buffer = StringBuffer();
    for (var i = 0; i < digitos.length; i++) {
      if (i > 0 && (digitos.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digitos[i]);
    }
    return buffer.toString();
  }
}

/// `TextInputFormatter` que aplica o agrupamento de milhar em tempo real
/// enquanto a pessoa digita o valor da fatura (ex: digitar "150000" mostra
/// "150.000" no campo). O cursor sempre vai para o fim do texto — é o
/// comportamento padrão de máscara de valor monetário, já que a edição
/// nesse tipo de campo é sempre digitar/apagar pela direita.
class MascaraValorGuarani extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final formatado = FormatadorMoeda.agruparMilhares(digitos);

    return TextEditingValue(
      text: formatado,
      selection: TextSelection.collapsed(offset: formatado.length),
    );
  }
}
