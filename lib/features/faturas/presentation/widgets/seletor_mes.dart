import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/utilitarios_mes.dart';
import '../../application/mes_selecionado_provider.dart';

class SeletorMes extends ConsumerWidget {
  const SeletorMes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mes = ref.watch(mesSelecionadoProvider);
    final localeCode = Localizations.localeOf(context).languageCode;
    final ehMesAtual = UtilitariosMes.ehMesAtual(mes);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () =>
              ref.read(mesSelecionadoProvider.notifier).irParaMesAnterior(),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          UtilitariosMes.rotulo(mes, localeCode),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          onPressed: ehMesAtual
              ? null
              : () =>
                    ref.read(mesSelecionadoProvider.notifier).irParaProximoMes(),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
