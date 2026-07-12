import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/configuracao_app.dart';
import 'core/notifications/servico_notificacoes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ConfiguracaoApp.validar();

  // URLs "limpas" no Web (sem #) — no-op em iOS/Android.
  usePathUrlStrategy();

  await Supabase.initialize(
    url: ConfiguracaoApp.urlSupabase,
    publishableKey: ConfiguracaoApp.chavePublicavelSupabase,
  );

  await ServicoNotificacoes.inicializar();

  runApp(const ProviderScope(child: App()));
}
