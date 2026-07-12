import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../application/usuarios_admin_provider.dart';

/// Sem fluxo de e-mail/SMTP: o admin define a senha na hora e a repassa
/// diretamente para quem vai usar a conta (ex: WhatsApp), o que é
/// suficiente para um app particular sem loja de aplicativos.
class DialogoCriarUsuario extends ConsumerStatefulWidget {
  const DialogoCriarUsuario({super.key});

  @override
  ConsumerState<DialogoCriarUsuario> createState() =>
      _DialogoCriarUsuarioState();
}

class _DialogoCriarUsuarioState extends ConsumerState<DialogoCriarUsuario> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _controladorEmail = TextEditingController();
  final _controladorSenha = TextEditingController();
  bool _criando = false;
  String? _erro;

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    super.dispose();
  }

  Future<void> _criar() async {
    final textos = AppLocalizations.of(context)!;
    if (!(_chaveFormulario.currentState?.validate() ?? false)) return;

    setState(() {
      _criando = true;
      _erro = null;
    });

    try {
      await ref
          .read(repositorioAdminProvider)
          .criarUsuario(
            email: _controladorEmail.text.trim(),
            senha: _controladorSenha.text,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) setState(() => _erro = textos.errorGeneric);
    } finally {
      if (mounted) setState(() => _criando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(textos.createUserButton),
      content: Form(
        key: _chaveFormulario,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _controladorEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: textos.newUserEmailLabel,
              ),
              validator: (valor) => (valor == null || valor.trim().isEmpty)
                  ? textos.emailRequired
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controladorSenha,
              decoration: InputDecoration(
                labelText: textos.newUserPasswordLabel,
              ),
              validator: (valor) => (valor == null || valor.length < 6)
                  ? textos.passwordRequired
                  : null,
            ),
            if (_erro != null) ...[
              const SizedBox(height: 12),
              Text(
                _erro!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _criando ? null : () => Navigator.of(context).pop(false),
          child: Text(textos.cancelButton),
        ),
        FilledButton(
          onPressed: _criando ? null : _criar,
          child: _criando
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(textos.createButton),
        ),
      ],
    );
  }
}
