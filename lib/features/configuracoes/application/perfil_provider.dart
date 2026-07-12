import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/provedores_supabase.dart';
import '../data/repositorio_perfil.dart';
import '../domain/perfil_usuario.dart';

final repositorioPerfilProvider = Provider<RepositorioPerfil>((ref) {
  return RepositorioPerfil(ref.watch(clienteSupabaseProvider));
});

/// `null` enquanto não há usuário autenticado. Depois de qualquer alteração
/// (ex: mudar dia de vencimento/idioma em Configurações), chamar
/// `ref.invalidate(perfilAtualProvider)` para refletir a mudança.
final perfilAtualProvider = FutureProvider<PerfilUsuario?>((ref) async {
  final usuario = ref.watch(usuarioAtualProvider);
  if (usuario == null) return null;
  return ref.watch(repositorioPerfilProvider).buscarPerfilAtual();
});
