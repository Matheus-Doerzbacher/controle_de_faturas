/// Credenciais do Supabase, injetadas em tempo de compilação via
/// `--dart-define-from-file=env.json` (ver env.example.json). Não usamos
/// nenhum pacote de .env — evita passo assíncrono antes do
/// `Supabase.initialize` e funciona igual em iOS/Android/Web.
class ConfiguracaoApp {
  ConfiguracaoApp._();

  static const String urlSupabase = String.fromEnvironment('SUPABASE_URL');

  /// Chave "publishable" do projeto (Project Settings → API) — é a chave
  /// pública, protegida pelas policies de RLS, não a service_role.
  static const String chavePublicavelSupabase = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  /// `String.fromEnvironment` nunca falha em tempo de build — se a flag não
  /// for passada, o valor vira string vazia. Essa checagem em runtime é o
  /// que de fato pega o esquecimento (asserts são removidos em release).
  static void validar() {
    if (urlSupabase.isEmpty || chavePublicavelSupabase.isEmpty) {
      throw StateError(
        'SUPABASE_URL e/ou SUPABASE_PUBLISHABLE_KEY não configurados. Rode o '
        'app com --dart-define-from-file=env.json (copie env.example.json '
        'para env.json e preencha com as credenciais do seu projeto '
        'Supabase).',
      );
    }
  }
}
