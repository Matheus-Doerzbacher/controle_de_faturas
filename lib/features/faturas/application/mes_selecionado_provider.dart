import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/utilitarios_mes.dart';

class MesSelecionadoNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => UtilitariosMes.mesAtual();

  void selecionar(DateTime mes) => state = UtilitariosMes.normalizar(mes);

  void irParaMesAnterior() => state = UtilitariosMes.mesAnterior(state);

  /// Não permite navegar para além do mês corrente.
  void irParaProximoMes() {
    if (!UtilitariosMes.ehMesAtual(state)) {
      state = UtilitariosMes.proximoMes(state);
    }
  }
}

final mesSelecionadoProvider = NotifierProvider<MesSelecionadoNotifier, DateTime>(
  MesSelecionadoNotifier.new,
);
