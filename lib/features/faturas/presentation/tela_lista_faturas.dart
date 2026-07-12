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
            child: faturasAsync.when(
              data: (faturas) {
                if (faturas.isEmpty) {
                  return Center(child: Text(textos.noInvoicesForMonth));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: faturas.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final fatura = faturas[index];
                    return ItemListaFatura(
                      fatura: fatura,
                      aoTocar: () =>
                          context.push('/faturas/editar', extra: fatura),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (erro, _) => Center(child: Text(textos.errorGeneric)),
            ),
          ),
        ),
      ),
    );
  }
}
