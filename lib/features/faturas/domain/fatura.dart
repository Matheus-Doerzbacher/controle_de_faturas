enum TipoFatura { entrada, saida }

class Fatura {
  const Fatura({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.valor,
    required this.descricao,
    required this.dataFatura,
    required this.criadoEm,
    required this.atualizadoEm,
    this.caminhoFoto,
  });

  final String id;
  final String usuarioId;
  final TipoFatura tipo;
  final int valor;
  final String descricao;
  final DateTime dataFatura;
  final String? caminhoFoto;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  factory Fatura.fromJson(Map<String, dynamic> json) {
    return Fatura(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      tipo: TipoFatura.values.byName(json['tipo'] as String),
      valor: json['valor'] as int,
      descricao: json['descricao'] as String,
      dataFatura: DateTime.parse(json['data_fatura'] as String),
      caminhoFoto: json['caminho_foto'] as String?,
      criadoEm: DateTime.parse(json['criado_em'] as String),
      atualizadoEm: DateTime.parse(json['atualizado_em'] as String),
    );
  }
}
