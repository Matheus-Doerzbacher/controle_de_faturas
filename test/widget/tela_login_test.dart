import 'package:controle_de_faturas/features/autenticacao/presentation/tela_login.dart';
import 'package:controle_de_faturas/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget envolverComApp() {
    return ProviderScope(
      child: MaterialApp(
        locale: const Locale('pt'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TelaLogin(),
      ),
    );
  }

  testWidgets('mostra os campos de e-mail e senha e o botão de entrar', (
    tester,
  ) async {
    await tester.pumpWidget(envolverComApp());

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('mostra erros de validação ao tentar entrar com campos vazios', (
    tester,
  ) async {
    await tester.pumpWidget(envolverComApp());

    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pump();

    expect(find.text('Informe o e-mail'), findsOneWidget);
    expect(find.text('Informe a senha'), findsOneWidget);
  });
}
