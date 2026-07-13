import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Seletor de data com a cara nativa de cada plataforma: `CupertinoDatePicker`
/// no iOS, `showDatePicker` (Material) nas demais.
Future<DateTime?> escolherData({
  required BuildContext context,
  required DateTime dataInicial,
  required DateTime primeiraData,
  required DateTime ultimaData,
}) {
  final ehIOS = Theme.of(context).platform == TargetPlatform.iOS;
  if (!ehIOS) {
    return showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: primeiraData,
      lastDate: ultimaData,
    );
  }
  return _escolherDataCupertino(
    context: context,
    dataInicial: dataInicial,
    primeiraData: primeiraData,
    ultimaData: ultimaData,
  );
}

Future<DateTime?> _escolherDataCupertino({
  required BuildContext context,
  required DateTime dataInicial,
  required DateTime primeiraData,
  required DateTime ultimaData,
}) async {
  var dataEscolhida = dataInicial;

  final confirmado = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (context) => Container(
      height: 320,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CupertinoButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('OK'),
              ),
            ],
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: dataInicial,
              minimumDate: primeiraData,
              maximumDate: ultimaData,
              onDateTimeChanged: (novaData) => dataEscolhida = novaData,
            ),
          ),
        ],
      ),
    ),
  );

  return confirmado == true ? dataEscolhida : null;
}
