import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Exibe uma foto de nota em tela cheia com zoom (pinça), já que letras em
/// fotos de notas fiscais costumam ficar pequenas demais na miniatura.
///
/// A foto preenche 100% da tela (equivalente a `object-fit: cover`): sem
/// distorcer a proporção, cortando o excesso quando necessário.
class TelaVisualizarFotoCheia extends StatelessWidget {
  const TelaVisualizarFotoCheia({super.key, required this.bytes});

  final Uint8List bytes;

  static void abrir(BuildContext context, Uint8List bytes) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => TelaVisualizarFotoCheia(bytes: bytes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 6,
        child: Image.memory(bytes, fit: BoxFit.cover),
      ),
    );
  }
}
