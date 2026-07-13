import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/configuracao_app.dart';
import 'core/notifications/servico_notificacoes.dart';

/// Riverpod não imprime erros de provider no console por padrão — sem isto,
/// um `FutureProvider` que falha (ex: uma query rejeitada pelo Postgrest)
/// vira só um estado `AsyncError` silencioso, sem rastro nenhum no debug
/// console.
final class _ObservadorErros extends ProviderObserver {
  const _ObservadorErros();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint('[provider erro] ${context.provider}: $error');
    debugPrint(stackTrace.toString());
  }
}

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

  runApp(
    const ProviderScope(
      observers: [_ObservadorErros()],
      child: App(),
    ),
  );
}
