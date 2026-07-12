import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/calculadora_lembrete.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../configuracoes/application/perfil_provider.dart';

/// No Web não há notificação local (flutter_local_notifications não
/// funciona nessa plataforma) — este banner é o equivalente dentro do app,
/// usando a mesma `CalculadoraLembrete` que agenda as notificações mobile.
class BannerLembreteWeb extends ConsumerWidget {
  const BannerLembreteWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kIsWeb) return const SizedBox.shrink();

    final perfil = ref.watch(perfilAtualProvider).value;
    if (perfil == null) return const SizedBox.shrink();

    final lembrete = CalculadoraLembrete.calcular(
      diaVencimento: perfil.diaVencimento,
      hoje: DateTime.now(),
    );
    if (lembrete == null) return const SizedBox.shrink();

    final textos = AppLocalizations.of(context)!;
    final mensagem = switch (lembrete) {
      TipoLembreteVencimento.faltamTresDias => textos.webBannerDaysLeft,
      TipoLembreteVencimento.ultimoDiaAmanha => textos.webBannerTomorrow,
      TipoLembreteVencimento.ultimoDiaHoje => textos.webBannerToday,
    };

    final cores = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cores.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: cores.onSecondaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              mensagem,
              style: TextStyle(color: cores.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
