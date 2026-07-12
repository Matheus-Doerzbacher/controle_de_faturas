import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/provedores_idioma.dart';
import 'core/router/roteador_app.dart';
import 'core/theme/tema_app.dart';
import 'l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roteador = ref.watch(roteadorAppProvider);
    final idiomaSelecionado = ref.watch(idiomaSelecionadoProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: TemaApp.claro,
      darkTheme: TemaApp.escuro,
      routerConfig: roteador,
      locale: idiomaSelecionado,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Padrão: segue o idioma do dispositivo, mas qualquer coisa que não
      // seja pt cai em es (espanhol é o idioma oficial do Paraguai e o
      // fallback mais seguro — inglês está fora do escopo do app).
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale?.languageCode == 'pt') return const Locale('pt');
        return const Locale('es');
      },
    );
  }
}
