import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/perfil_usuario.dart';

class RepositorioPerfil {
  RepositorioPerfil(this._client);

  final SupabaseClient _client;

  static const _tabela = 'perfis';

  Future<PerfilUsuario> buscarPerfilAtual() async {
    final usuarioId = _client.auth.currentUser!.id;
    final linha = await _client
        .from(_tabela)
        .select()
        .eq('id', usuarioId)
        .single();
    return PerfilUsuario.fromJson(linha);
  }

  Future<PerfilUsuario> atualizarDiaVencimento(int diaVencimento) async {
    final usuarioId = _client.auth.currentUser!.id;
    final linha = await _client
        .from(_tabela)
        .update({'dia_vencimento': diaVencimento})
        .eq('id', usuarioId)
        .select()
        .single();
    return PerfilUsuario.fromJson(linha);
  }

  Future<PerfilUsuario> atualizarIdioma(String idioma) async {
    final usuarioId = _client.auth.currentUser!.id;
    final linha = await _client
        .from(_tabela)
        .update({'idioma': idioma})
        .eq('id', usuarioId)
        .select()
        .single();
    return PerfilUsuario.fromJson(linha);
  }
}
