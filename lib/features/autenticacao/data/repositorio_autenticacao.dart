import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/provedores_supabase.dart';

/// Sem cadastro público — contas são criadas por um admin (ver feature
/// `admin`), então este repositório expõe só entrar/sair.
class RepositorioAutenticacao {
  RepositorioAutenticacao(this._client);

  final SupabaseClient _client;

  Future<void> entrar({required String email, required String senha}) {
    return _client.auth.signInWithPassword(email: email, password: senha);
  }

  Future<void> sair() {
    return _client.auth.signOut();
  }

  Future<void> atualizarSenha(String novaSenha) {
    return _client.auth.updateUser(UserAttributes(password: novaSenha));
  }
}

final repositorioAutenticacaoProvider = Provider<RepositorioAutenticacao>((
  ref,
) {
  return RepositorioAutenticacao(ref.watch(clienteSupabaseProvider));
});
