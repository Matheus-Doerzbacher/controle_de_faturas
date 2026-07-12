import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/provedores_supabase.dart';
import '../../../core/theme/tema_app.dart';
import '../../../l10n/app_localizations.dart';
import '../application/usuarios_admin_provider.dart';
import '../data/repositorio_admin.dart';
import 'dialogo_criar_usuario.dart';

class TelaAdmin extends ConsumerWidget {
  const TelaAdmin({super.key});

  Future<void> _confirmarRemocao(
    BuildContext context,
    WidgetRef ref,
    UsuarioAdmin usuario,
  ) async {
    final textos = AppLocalizations.of(context)!;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(textos.removeUserConfirmTitle),
        content: Text(textos.removeUserConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(textos.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(textos.removeUserButton),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await ref.read(repositorioAdminProvider).removerUsuario(usuario.id);
      ref.invalidate(usuariosAdminProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(textos.errorGeneric)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context)!;
    final usuariosAsync = ref.watch(usuariosAdminProvider);
    final usuarioAtualId = ref.watch(usuarioAtualProvider)?.id;

    return Scaffold(
      appBar: AppBar(title: Text(textos.adminTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final criado = await showDialog<bool>(
            context: context,
            builder: (context) => const DialogoCriarUsuario(),
          );
          if (criado == true) ref.invalidate(usuariosAdminProvider);
        },
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: Text(textos.createUserButton),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: TemaApp.larguraMaximaConteudo,
            ),
            child: usuariosAsync.when(
              data: (usuarios) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: usuarios.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  final ehVoceMesmo = usuario.id == usuarioAtualId;
                  return ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(usuario.email),
                    trailing: ehVoceMesmo
                        ? Tooltip(
                            message: textos.cannotRemoveSelf,
                            child: const Icon(Icons.lock_outline),
                          )
                        : IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                _confirmarRemocao(context, ref, usuario),
                          ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (erro, _) => Center(child: Text(textos.errorGeneric)),
            ),
          ),
        ),
      ),
    );
  }
}
