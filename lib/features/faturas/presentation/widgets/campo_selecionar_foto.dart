import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../l10n/app_localizations.dart';

/// Uma foto por fatura. No mobile oferece câmera ou galeria; no Web (sem
/// câmera nativa acessível de forma consistente) o próprio `image_picker`
/// resolve para o seletor de arquivos do navegador em ambas as opções.
class CampoSelecionarFoto extends StatelessWidget {
  const CampoSelecionarFoto({
    super.key,
    required this.bytesAtuais,
    required this.aoSelecionar,
    required this.aoRemover,
  });

  final Uint8List? bytesAtuais;
  final ValueChanged<Uint8List> aoSelecionar;
  final VoidCallback aoRemover;

  Future<void> _abrirSeletor(BuildContext context) async {
    final textos = AppLocalizations.of(context)!;
    final origem = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(textos.takePhotoOption),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(textos.pickFromGalleryOption),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (origem == null || !context.mounted) return;

    final arquivo = await ImagePicker().pickImage(
      source: origem,
      imageQuality: 80,
    );
    if (arquivo == null) return;

    final bytes = await arquivo.readAsBytes();
    aoSelecionar(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textos.photoLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        if (bytesAtuais != null) ...[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  bytesAtuais!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton.filled(
                  onPressed: aoRemover,
                  tooltip: textos.removePhotoButton,
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => _abrirSeletor(context),
            child: Text(textos.changePhotoButton),
          ),
        ] else
          OutlinedButton.icon(
            onPressed: () => _abrirSeletor(context),
            icon: const Icon(Icons.add_a_photo_outlined),
            label: Text(textos.addPhotoButton),
          ),
      ],
    );
  }
}
