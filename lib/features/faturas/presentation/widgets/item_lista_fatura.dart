import 'package:flutter/material.dart';

import '../../../../core/theme/tema_app.dart';
import '../../../../core/utils/formatador_moeda.dart';
import '../../domain/fatura.dart';

class ItemListaFatura extends StatelessWidget {
  const ItemListaFatura({
    super.key,
    required this.fatura,
    required this.aoTocar,
  });

  final Fatura fatura;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final ehEntrada = fatura.tipo == TipoFatura.entrada;
    final cor = ehEntrada ? context.corEntrada : context.corSaida;

    return ListTile(
      onTap: aoTocar,
      leading: CircleAvatar(
        backgroundColor: cor.withValues(alpha: 0.15),
        child: Icon(
          ehEntrada ? Icons.arrow_downward : Icons.arrow_upward,
          color: cor,
        ),
      ),
      title: Text(fatura.descricao),
      subtitle: Text(_formatarDataExibicao(fatura.dataFatura)),
      trailing: Text(
        FormatadorMoeda.formatar(fatura.valor),
        style: TextStyle(color: cor, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatarDataExibicao(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }
}
