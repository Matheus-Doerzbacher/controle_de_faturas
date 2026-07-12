import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/provedores_idioma.dart';
import '../../../core/notifications/servico_notificacoes.dart';
import '../../../core/theme/tema_app.dart';
import '../../../l10n/app_localizations.dart';
import '../../autenticacao/data/repositorio_autenticacao.dart';
import '../application/perfil_provider.dart';

class TelaConfiguracoes extends ConsumerWidget {
  const TelaConfiguracoes({super.key});

  // 4–28: garante que D-3/D-2/D-1 nunca cruzem mês, requisito da
  // recorrência "dia fixo do mês" das notificações (ver ServicoNotificacoes).
  static const _diaVencimentoMinimo = 4;
  static const _diaVencimentoMaximo = 28;

  Future<void> _mudarDiaVencimento(WidgetRef ref, int novoDia) async {
    final perfilAtualizado = await ref
        .read(repositorioPerfilProvider)
        .atualizarDiaVencimento(novoDia);
    ref.invalidate(perfilAtualProvider);
    await ServicoNotificacoes.reagendarLembretes(
      diaVencimento: perfilAtualizado.diaVencimento,
      localeCode: perfilAtualizado.idioma,
    );
  }

  Future<void> _mudarIdioma(WidgetRef ref, String novoIdioma) async {
    await ref
        .read(idiomaSelecionadoProvider.notifier)
        .definir(Locale(novoIdioma));
    final perfilAtualizado = await ref
        .read(repositorioPerfilProvider)
        .atualizarIdioma(novoIdioma);
    ref.invalidate(perfilAtualProvider);
    // O texto das notificações é fixado no momento do agendamento, não do
    // disparo — por isso mudar o idioma também reagenda.
    await ServicoNotificacoes.reagendarLembretes(
      diaVencimento: perfilAtualizado.diaVencimento,
      localeCode: novoIdioma,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context)!;
    final perfilAsync = ref.watch(perfilAtualProvider);

    return Scaffold(
      appBar: AppBar(title: Text(textos.settingsTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: TemaApp.larguraMaximaConteudo,
            ),
            child: perfilAsync.when(
              data: (perfil) {
                if (perfil == null) return const SizedBox.shrink();
                final idiomaAtual =
                    Localizations.localeOf(context).languageCode == 'pt'
                    ? 'pt'
                    : 'es';

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      textos.dueDayLabel,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      textos.dueDayHelper,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: perfil.diaVencimento,
                      items: [
                        for (
                          var dia = _diaVencimentoMinimo;
                          dia <= _diaVencimentoMaximo;
                          dia++
                        )
                          DropdownMenuItem(value: dia, child: Text('$dia')),
                      ],
                      onChanged: (novoDia) {
                        if (novoDia != null) {
                          _mudarDiaVencimento(ref, novoDia);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      textos.languageLabel,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(
                          value: 'pt',
                          label: Text(textos.portugueseOption),
                        ),
                        ButtonSegment(
                          value: 'es',
                          label: Text(textos.spanishOption),
                        ),
                      ],
                      selected: {idiomaAtual},
                      onSelectionChanged: (selecionados) =>
                          _mudarIdioma(ref, selecionados.first),
                    ),
                    const SizedBox(height: 32),
                    if (perfil.administrador)
                      ListTile(
                        leading: const Icon(
                          Icons.admin_panel_settings_outlined,
                        ),
                        title: Text(textos.adminShortcut),
                        onTap: () => context.push('/admin'),
                      ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(textos.logoutButton),
                      onTap: () =>
                          ref.read(repositorioAutenticacaoProvider).sair(),
                    ),
                  ],
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
