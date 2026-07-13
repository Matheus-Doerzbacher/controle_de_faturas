import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tema_app.dart';
import '../../../l10n/app_localizations.dart';
import '../../configuracoes/application/perfil_provider.dart';
import '../application/totais_fatura_provider.dart';
import 'widgets/banner_lembrete_web.dart';
import 'widgets/grafico_entrada_saida.dart';
import 'widgets/seletor_mes.dart';

class TelaInicial extends ConsumerWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context)!;
    final totaisAsync = ref.watch(totaisFaturaProvider);
    final perfil = ref.watch(perfilAtualProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(textos.homeTitle),
        actions: [
          if (perfil?.administrador ?? false)
            IconButton(
              tooltip: textos.adminShortcut,
              icon: const Icon(Icons.admin_panel_settings_outlined),
              onPressed: () => context.push('/admin'),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/configuracoes'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: TemaApp.larguraMaximaConteudo,
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const BannerLembreteWeb(),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    child: Column(
                      children: [
                        const SeletorMes(),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          // skipLoadingOn* em false: ao trocar de mês
                          // queremos sempre o spinner, nunca os valores do
                          // mês anterior piscando até a busca nova terminar
                          // (comportamento padrão do Riverpod é o oposto,
                          // pensado pra telas onde o dado "atualiza",
                          // não pra quando o dado é de outro período).
                          child: totaisAsync.when(
                            skipLoadingOnReload: false,
                            skipLoadingOnRefresh: false,
                            data: (totais) => GraficoEntradaSaida(
                              key: const ValueKey('grafico'),
                              totais: totais,
                            ),
                            loading: () => const Padding(
                              key: ValueKey('carregando'),
                              padding: EdgeInsets.symmetric(vertical: 48),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            error: (erro, _) => Padding(
                              key: const ValueKey('erro'),
                              padding: const EdgeInsets.symmetric(
                                vertical: 48,
                              ),
                              child: Center(child: Text(textos.errorGeneric)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () =>
                            context.push('/faturas/novo?tipo=entrada'),
                        icon: const Icon(Icons.add),
                        label: Text(textos.addEntradaButton),
                        style: FilledButton.styleFrom(
                          backgroundColor: context.corEntrada.withValues(
                            alpha: 0.15,
                          ),
                          foregroundColor: context.corEntrada,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () =>
                            context.push('/faturas/novo?tipo=saida'),
                        icon: const Icon(Icons.add),
                        label: Text(textos.addSaidaButton),
                        style: FilledButton.styleFrom(
                          backgroundColor: context.corSaida.withValues(
                            alpha: 0.15,
                          ),
                          foregroundColor: context.corSaida,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push('/faturas'),
                  icon: const Icon(Icons.list_alt_outlined),
                  label: Text(textos.viewAllButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
