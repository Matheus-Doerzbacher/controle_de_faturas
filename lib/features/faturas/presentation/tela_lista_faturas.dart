import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tema_app.dart';
import '../../../core/utils/utilitarios_mes.dart';
import '../../../l10n/app_localizations.dart';
import '../application/faturas_do_mes_provider.dart';
import '../application/mes_selecionado_provider.dart';
import 'widgets/item_lista_fatura.dart';

class TelaListaFaturas extends ConsumerWidget {
  const TelaListaFaturas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context)!;
    final mes = ref.watch(mesSelecionadoProvider);
    final faturasAsync = ref.watch(faturasDoMesProvider(mes));
    final localeCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          textos.allInvoicesTitle(UtilitariosMes.rotulo(mes, localeCode)),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: TemaApp.larguraMaximaConteudo,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                // Ver comentário equivalente em tela_inicial.dart: sempre
                // mostrar o carregando ao trocar de mês, nunca a lista do
                // mês anterior parada.
                child: faturasAsync.when(
                  skipLoadingOnReload: false,
                  skipLoadingOnRefresh: false,
                  data: (faturas) {
                    if (faturas.isEmpty) {
                      return _EstadoVazio(
                        key: const ValueKey('vazio'),
                        mensagem: textos.noInvoicesForMonth,
                      );
                    }
                    return Card(
                      key: const ValueKey('lista'),
                      clipBehavior: Clip.antiAlias,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: faturas.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final fatura = faturas[index];
                          return ItemListaFatura(
                            fatura: fatura,
                            aoTocar: () =>
                                context.push('/faturas/editar', extra: fatura),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    key: ValueKey('carregando'),
                    child: CircularProgressIndicator(),
                  ),
                  error: (erro, _) => Center(
                    key: const ValueKey('erro'),
                    child: Text(textos.errorGeneric),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio({super.key, required this.mensagem});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: cores.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            mensagem,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: cores.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
