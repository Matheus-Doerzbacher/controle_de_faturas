/// Os três lembretes de vencimento que o app pode disparar num dado dia,
/// sempre em relação às faturas do mês anterior.
enum TipoLembreteVencimento { faltamTresDias, ultimoDiaAmanha, ultimoDiaHoje }

/// Função pura, sem dependências de plataforma: dado o dia de vencimento
/// configurado e a data de hoje, diz qual lembrete (se algum) se aplica.
/// Reaproveitada tanto pelo agendamento de notificações locais (mobile)
/// quanto pelo banner exibido dentro do app no Web.
class CalculadoraLembrete {
  CalculadoraLembrete._();

  static TipoLembreteVencimento? calcular({
    required int diaVencimento,
    required DateTime hoje,
  }) {
    final dia = hoje.day;
    if (dia == diaVencimento - 3) return TipoLembreteVencimento.faltamTresDias;
    if (dia == diaVencimento - 2) return TipoLembreteVencimento.ultimoDiaAmanha;
    if (dia == diaVencimento - 1) return TipoLembreteVencimento.ultimoDiaHoje;
    return null;
  }
}
