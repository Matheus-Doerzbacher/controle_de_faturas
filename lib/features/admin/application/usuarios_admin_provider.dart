import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/provedores_supabase.dart';
import '../data/repositorio_admin.dart';

final repositorioAdminProvider = Provider<RepositorioAdmin>((ref) {
  return RepositorioAdmin(ref.watch(clienteSupabaseProvider));
});

final usuariosAdminProvider = FutureProvider<List<UsuarioAdmin>>((ref) {
  return ref.watch(repositorioAdminProvider).listarUsuarios();
});
