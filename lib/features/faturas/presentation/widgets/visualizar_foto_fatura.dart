import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/faturas_do_mes_provider.dart';
import 'tela_visualizar_foto_cheia.dart';

/// O bucket de fotos é privado — baixamos os bytes pelo client autenticado
/// (RLS de storage aplica sozinha) em vez de usar `Image.network` com uma
/// URL assinada. `FutureProvider.family` já dá cache por caminho de graça.
final _fotoFaturaProvider = FutureProvider.family<Uint8List, String>((
  ref,
  caminho,
) {
  return ref.watch(repositorioFaturasProvider).baixarFoto(caminho);
});

class VisualizarFotoFatura extends ConsumerWidget {
  const VisualizarFotoFatura({
    super.key,
    required this.caminhoFoto,
    this.altura = 160,
  });

  final String caminhoFoto;
  final double altura;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fotoAsync = ref.watch(_fotoFaturaProvider(caminhoFoto));

    return fotoAsync.when(
      data: (bytes) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GestureDetector(
          onTap: () => TelaVisualizarFotoCheia.abrir(context, bytes),
          child: Image.memory(
            bytes,
            height: altura,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
      loading: () => SizedBox(
        height: altura,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => SizedBox(
        height: altura,
        child: const Center(child: Icon(Icons.broken_image_outlined)),
      ),
    );
  }
}
