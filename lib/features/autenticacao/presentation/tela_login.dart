import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/repositorio_autenticacao.dart';

class TelaLogin extends ConsumerStatefulWidget {
  const TelaLogin({super.key});

  @override
  ConsumerState<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends ConsumerState<TelaLogin> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _controladorEmail = TextEditingController();
  final _controladorSenha = TextEditingController();
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final textos = AppLocalizations.of(context)!;
    if (!(_chaveFormulario.currentState?.validate() ?? false)) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      await ref
          .read(repositorioAutenticacaoProvider)
          .entrar(
            email: _controladorEmail.text.trim(),
            senha: _controladorSenha.text,
          );
      // O roteador redireciona automaticamente ao detectar a nova sessão.
    } catch (_) {
      if (mounted) setState(() => _erro = textos.loginError);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context)!;
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, progresso, filho) => Opacity(
                  opacity: progresso,
                  child: Transform.translate(
                    offset: Offset(0, (1 - progresso) * 20),
                    child: filho,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: cores.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        size: 36,
                        color: cores.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      textos.appTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _chaveFormulario,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _controladorEmail,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: InputDecoration(
                                  labelText: textos.emailLabel,
                                  prefixIcon: const Icon(
                                    Icons.mail_outline,
                                  ),
                                ),
                                validator: (valor) =>
                                    (valor == null || valor.trim().isEmpty)
                                    ? textos.emailRequired
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _controladorSenha,
                                obscureText: true,
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  labelText: textos.passwordLabel,
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                  ),
                                ),
                                validator: (valor) =>
                                    (valor == null || valor.isEmpty)
                                    ? textos.passwordRequired
                                    : null,
                                onFieldSubmitted: (_) => _entrar(),
                              ),
                              if (_erro != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  _erro!,
                                  style: TextStyle(color: cores.error),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: _carregando ? null : _entrar,
                                  child: _carregando
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(textos.loginButton),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
