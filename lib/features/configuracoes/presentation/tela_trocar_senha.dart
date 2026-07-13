import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tema_app.dart';
import '../../../l10n/app_localizations.dart';
import '../../autenticacao/data/repositorio_autenticacao.dart';
import '../application/perfil_provider.dart';

/// Usada em dois fluxos: obrigatório (logo após login, quando
/// `perfil.deveTrocarSenha == true` — sem botão de voltar) e voluntário
/// (a partir das Configurações, a qualquer momento — com botão de voltar).
/// Qual dos dois está em curso é decidido lendo o perfil atual, não por um
/// parâmetro de rota.
class TelaTrocarSenha extends ConsumerStatefulWidget {
  const TelaTrocarSenha({super.key});

  @override
  ConsumerState<TelaTrocarSenha> createState() => _TelaTrocarSenhaState();
}

class _TelaTrocarSenhaState extends ConsumerState<TelaTrocarSenha> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _controladorNovaSenha = TextEditingController();
  final _controladorConfirmarSenha = TextEditingController();
  bool _salvando = false;

  @override
  void dispose() {
    _controladorNovaSenha.dispose();
    _controladorConfirmarSenha.dispose();
    super.dispose();
  }

  Future<void> _salvar({required bool obrigatorio}) async {
    final textos = AppLocalizations.of(context)!;
    if (!(_chaveFormulario.currentState?.validate() ?? false)) return;

    setState(() => _salvando = true);

    try {
      await ref
          .read(repositorioAutenticacaoProvider)
          .atualizarSenha(_controladorNovaSenha.text);
      await ref.read(repositorioPerfilProvider).marcarSenhaAlterada();
      ref.invalidate(perfilAtualProvider);

      if (!mounted) return;
      if (obrigatorio) {
        context.go('/inicio');
      } else {
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(textos.errorGeneric)));
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context)!;
    final perfil = ref.watch(perfilAtualProvider).value;
    final obrigatorio = perfil?.deveTrocarSenha ?? false;

    return PopScope(
      canPop: !obrigatorio,
      child: Scaffold(
        appBar: AppBar(
          title: Text(textos.changePasswordTitle),
          automaticallyImplyLeading: !obrigatorio,
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: TemaApp.larguraMaximaConteudo,
              ),
              child: Form(
                key: _chaveFormulario,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (obrigatorio) ...[
                      Text(
                        textos.mandatoryPasswordChangeMessage,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                    ],
                    TextFormField(
                      controller: _controladorNovaSenha,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: textos.newPasswordLabel,
                      ),
                      validator: (valor) => (valor == null || valor.length < 6)
                          ? textos.passwordTooShort
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _controladorConfirmarSenha,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: textos.confirmPasswordLabel,
                      ),
                      validator: (valor) =>
                          valor != _controladorNovaSenha.text
                          ? textos.passwordMismatch
                          : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _salvando
                          ? null
                          : () => _salvar(obrigatorio: obrigatorio),
                      child: _salvando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(textos.saveButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
