import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/fatura.dart';
import 'faturas_do_mes_provider.dart';
import 'mes_selecionado_provider.dart';

class TotaisFatura {
  const TotaisFatura({required this.entrada, required this.saida});

  final int entrada;
  final int saida;

  int get diferenca => entrada - saida;
}

/// Deriva os totais de entrada/saída do mês selecionado a partir de
/// `faturasDoMesProvider` — soma no client, já que o volume mensal de
/// faturas de um único usuário é pequeno o bastante para não justificar
/// uma agregação no banco.
final totaisFaturaProvider = Provider<AsyncValue<TotaisFatura>>((ref) {
  final mes = ref.watch(mesSelecionadoProvider);
  final faturasAsync = ref.watch(faturasDoMesProvider(mes));

  return faturasAsync.whenData((faturas) {
    var entrada = 0;
    var saida = 0;
    for (final fatura in faturas) {
      if (fatura.tipo == TipoFatura.entrada) {
        entrada += fatura.valor;
      } else {
        saida += fatura.valor;
      }
    }
    return TotaisFatura(entrada: entrada, saida: saida);
  });
});
