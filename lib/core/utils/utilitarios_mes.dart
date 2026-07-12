import 'package:intl/intl.dart';

/// Helpers para trabalhar com "o mês selecionado" como uma unidade —
/// sempre normalizado para o dia 1, sem componente de hora.
class UtilitariosMes {
  UtilitariosMes._();

  static DateTime normalizar(DateTime data) => DateTime(data.year, data.month);

  static DateTime mesAtual() => normalizar(DateTime.now());

  static DateTime mesAnterior(DateTime mes) {
    final m = normalizar(mes);
    return DateTime(m.year, m.month - 1);
  }

  static DateTime proximoMes(DateTime mes) {
    final m = normalizar(mes);
    return DateTime(m.year, m.month + 1);
  }

  static DateTime primeiroDia(DateTime mes) => normalizar(mes);

  /// Dia 0 do mês seguinte é o último dia do mês atual — cobre corretamente
  /// meses de 28/29/30/31 dias sem tabela de exceções.
  static DateTime ultimoDia(DateTime mes) {
    final m = normalizar(mes);
    return DateTime(m.year, m.month + 1, 0);
  }

  static bool ehMesAtual(DateTime mes) => normalizar(mes) == mesAtual();

  static String rotulo(DateTime mes, String localeCode) {
    final formatado = DateFormat.yMMMM(localeCode).format(mes);
    return formatado[0].toUpperCase() + formatado.substring(1);
  }

  /// Formato `yyyy-MM-dd` esperado pela coluna `date` do Postgres.
  static String formatarDataIso(DateTime data) {
    final ano = data.year.toString().padLeft(4, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');
    return '$ano-$mes-$dia';
  }
}
