import 'package:controle_de_faturas/features/faturas/application/totais_fatura_provider.dart';
import 'package:controle_de_faturas/features/faturas/presentation/widgets/grafico_entrada_saida.dart';
import 'package:controle_de_faturas/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget envolverComApp(Widget filho) {
    return MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: filho),
    );
  }

  testWidgets('mostra os valores formatados de entrada, saída e diferença', (
    tester,
  ) async {
    const totais = TotaisFatura(entrada: 500000, saida: 200000);

    await tester.pumpWidget(
      envolverComApp(const GraficoEntradaSaida(totais: totais)),
    );

    expect(find.textContaining('Gs. 500.000'), findsOneWidget);
    expect(find.textContaining('Gs. 200.000'), findsOneWidget);
    expect(find.textContaining('Gs. 300.000'), findsOneWidget);
  });

  testWidgets('funciona com totais zerados sem lançar erro', (tester) async {
    const totais = TotaisFatura(entrada: 0, saida: 0);

    await tester.pumpWidget(
      envolverComApp(const GraficoEntradaSaida(totais: totais)),
    );

    expect(find.byType(GraficoEntradaSaida), findsOneWidget);
  });
}
