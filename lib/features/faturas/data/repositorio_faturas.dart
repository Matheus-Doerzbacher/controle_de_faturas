import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/utilitarios_mes.dart';
import '../domain/fatura.dart';

class RepositorioFaturas {
  RepositorioFaturas(this._client);

  final SupabaseClient _client;

  static const _tabela = 'faturas';
  static const _bucket = 'fotos-faturas';

  Future<List<Fatura>> buscarPorMes(DateTime mes) async {
    final usuarioId = _client.auth.currentUser!.id;
    final linhas = await _client
        .from(_tabela)
        .select()
        .eq('usuario_id', usuarioId)
        .gte('data_fatura', UtilitariosMes.formatarDataIso(UtilitariosMes.primeiroDia(mes)))
        .lte('data_fatura', UtilitariosMes.formatarDataIso(UtilitariosMes.ultimoDia(mes)))
        .order('data_fatura', ascending: false);

    return linhas.map((linha) => Fatura.fromJson(linha)).toList();
  }

  Future<Fatura> criar({
    required TipoFatura tipo,
    required int valor,
    required String descricao,
    required DateTime dataFatura,
    Uint8List? bytesFoto,
  }) async {
    final usuarioId = _client.auth.currentUser!.id;

    final linhaInserida = await _client
        .from(_tabela)
        .insert({
          'usuario_id': usuarioId,
          'tipo': tipo.name,
          'valor': valor,
          'descricao': descricao,
          'data_fatura': UtilitariosMes.formatarDataIso(dataFatura),
        })
        .select()
        .single();

    var fatura = Fatura.fromJson(linhaInserida);

    if (bytesFoto != null) {
      final caminho = '$usuarioId/${fatura.id}.jpg';
      await _client.storage
          .from(_bucket)
          .uploadBinary(caminho, bytesFoto, fileOptions: const FileOptions(upsert: true));

      final linhaComFoto = await _client
          .from(_tabela)
          .update({'caminho_foto': caminho})
          .eq('id', fatura.id)
          .select()
          .single();
      fatura = Fatura.fromJson(linhaComFoto);
    }

    return fatura;
  }

  Future<Fatura> atualizar({
    required Fatura fatura,
    required int valor,
    required String descricao,
    required DateTime dataFatura,
    Uint8List? bytesNovaFoto,
    bool removerFoto = false,
  }) async {
    final usuarioId = _client.auth.currentUser!.id;
    var caminhoFoto = fatura.caminhoFoto;

    if (bytesNovaFoto != null) {
      caminhoFoto = '$usuarioId/${fatura.id}.jpg';
      await _client.storage
          .from(_bucket)
          .uploadBinary(caminhoFoto, bytesNovaFoto, fileOptions: const FileOptions(upsert: true));
    } else if (removerFoto && fatura.caminhoFoto != null) {
      await _client.storage.from(_bucket).remove([fatura.caminhoFoto!]);
      caminhoFoto = null;
    }

    final linha = await _client
        .from(_tabela)
        .update({
          'valor': valor,
          'descricao': descricao,
          'data_fatura': UtilitariosMes.formatarDataIso(dataFatura),
          'caminho_foto': caminhoFoto,
        })
        .eq('id', fatura.id)
        .select()
        .single();

    return Fatura.fromJson(linha);
  }

  Future<void> excluir(Fatura fatura) async {
    if (fatura.caminhoFoto != null) {
      await _client.storage.from(_bucket).remove([fatura.caminhoFoto!]);
    }
    await _client.from(_tabela).delete().eq('id', fatura.id);
  }

  Future<Uint8List> baixarFoto(String caminho) {
    return _client.storage.from(_bucket).download(caminho);
  }
}
