import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final clienteSupabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final estadoAutenticacaoProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(clienteSupabaseProvider);
  return client.auth.onAuthStateChange;
});

/// Reativo a login/logout via `estadoAutenticacaoProvider`, com fallback
/// síncrono em `currentUser` para já ter um valor antes do stream emitir.
final usuarioAtualProvider = Provider<User?>((ref) {
  final estado = ref.watch(estadoAutenticacaoProvider);
  return estado.value?.session?.user ??
      ref.watch(clienteSupabaseProvider).auth.currentUser;
});
