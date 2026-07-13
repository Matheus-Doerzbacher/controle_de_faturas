class PerfilUsuario {
  const PerfilUsuario({
    required this.id,
    required this.diaVencimento,
    required this.idioma,
    required this.administrador,
    required this.deveTrocarSenha,
  });

  final String id;
  final int diaVencimento;
  final String idioma;
  final bool administrador;
  final bool deveTrocarSenha;

  factory PerfilUsuario.fromJson(Map<String, dynamic> json) {
    return PerfilUsuario(
      id: json['id'] as String,
      diaVencimento: json['dia_vencimento'] as int,
      idioma: json['idioma'] as String,
      administrador: json['administrador'] as bool,
      deveTrocarSenha: json['deve_trocar_senha'] as bool,
    );
  }
}
