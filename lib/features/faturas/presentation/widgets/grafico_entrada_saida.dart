import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/tema_app.dart';
import '../../../../core/utils/formatador_moeda.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/totais_fatura_provider.dart';

/// Entrada/saída como identidade categórica (ver `tema_app.dart`): as duas
/// cores, valores em texto sobre cada barra e uma legenda por extenso — não
/// dependemos só da cor para diferenciar as séries.
class GraficoEntradaSaida extends StatelessWidget {
  const GraficoEntradaSaida({super.key, required this.totais});

  final TotaisFatura totais;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context)!;
    final corEntrada = context.corEntrada;
    final corSaida = context.corSaida;
    final maiorValor = [
      totais.entrada,
      totais.saida,
      1,
    ].reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: maiorValor * 1.25,
              alignment: BarChartAlignment.spaceAround,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (valor, meta) {
                      final texto = valor == 0
                          ? textos.entradaLabel
                          : textos.saidaLabel;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          texto,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                _grupoBarra(
                  x: 0,
                  valor: totais.entrada,
                  cor: corEntrada,
                  context: context,
                ),
                _grupoBarra(
                  x: 1,
                  valor: totais.saida,
                  cor: corSaida,
                  context: context,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Legenda(
              cor: corEntrada,
              rotulo: textos.entradaLabel,
              valor: totais.entrada,
            ),
            const SizedBox(width: 24),
            _Legenda(
              cor: corSaida,
              rotulo: textos.saidaLabel,
              valor: totais.saida,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${textos.differenceLabel}: ${FormatadorMoeda.formatar(totais.diferenca)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  BarChartGroupData _grupoBarra({
    required int x,
    required int valor,
    required Color cor,
    required BuildContext context,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: valor.toDouble(),
          color: cor,
          width: 40,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}

class _Legenda extends StatelessWidget {
  const _Legenda({required this.cor, required this.rotulo, required this.valor});

  final Color cor;
  final String rotulo;
  final int valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$rotulo: ${FormatadorMoeda.formatar(valor)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
