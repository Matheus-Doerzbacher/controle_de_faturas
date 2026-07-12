/// Formata valores em Guarani, sem casas decimais e com ponto como
/// separador de milhar (ex: "₲ 150.000") — não depende de dados de locale
/// do `intl`, então funciona de forma determinística em qualquer plataforma.
class FormatadorMoeda {
  FormatadorMoeda._();

  static String formatar(int valor) {
    final digitos = valor.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digitos.length; i++) {
      if (i > 0 && (digitos.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digitos[i]);
    }
    final sinal = valor < 0 ? '-' : '';
    return '$sinal₲ $buffer';
  }
}
