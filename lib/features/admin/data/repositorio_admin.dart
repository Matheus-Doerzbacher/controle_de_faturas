import 'package:supabase_flutter/supabase_flutter.dart';

class UsuarioAdmin {
  const UsuarioAdmin({
    required this.id,
    required this.email,
    required this.criadoEm,
  });

  final String id;
  final String email;
  final DateTime criadoEm;

  factory UsuarioAdmin.fromJson(Map<String, dynamic> json) {
    return UsuarioAdmin(
      id: json['id'] as String,
      email: json['email'] as String,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
    );
  }
}

/// Fala com a Edge Function `gerenciar-usuarios`, a única peça que usa a
/// service_role key (nunca embutida no app) para criar/remover contas. Sem
/// cadastro público, é assim que novos usuários passam a existir.
class RepositorioAdmin {
  RepositorioAdmin(this._client);

  final SupabaseClient _client;

  static const _funcao = 'gerenciar-usuarios';

  Future<List<UsuarioAdmin>> listarUsuarios() async {
    final resposta = await _invocar({'acao': 'listar'});
    final lista = (resposta.data as Map<String, dynamic>)['usuarios'] as List;
    return lista
        .map(
          (usuario) => UsuarioAdmin.fromJson(usuario as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> criarUsuario({required String email, required String senha}) {
    return _invocar({'acao': 'criar', 'email': email, 'senha': senha});
  }

  Future<void> removerUsuario(String usuarioId) {
    return _invocar({'acao': 'remover', 'usuarioId': usuarioId});
  }

  Future<FunctionResponse> _invocar(Map<String, dynamic> corpo) async {
    try {
      return await _client.functions.invoke(_funcao, body: corpo);
    } on FunctionException catch (erro) {
      final detalhes = erro.details;
      final mensagem = detalhes is Map ? detalhes['erro'] as String? : null;
      throw Exception(mensagem ?? 'Erro ao chamar a função de administração');
    }
  }
}
