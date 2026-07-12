import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _chavePreferenciaIdioma = 'idioma_selecionado';

/// `null` = segue o idioma do dispositivo (ver `localeResolutionCallback`
/// em app.dart). Um `Locale` explícito = usuário sobrescreveu manualmente
/// nas Configurações.
class IdiomaSelecionadoNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    _carregarPreferenciaSalva();
    return null;
  }

  Future<void> _carregarPreferenciaSalva() async {
    final preferencias = await SharedPreferences.getInstance();
    final codigo = preferencias.getString(_chavePreferenciaIdioma);
    if (codigo != null) {
      state = Locale(codigo);
    }
  }

  Future<void> definir(Locale? idioma) async {
    state = idioma;
    final preferencias = await SharedPreferences.getInstance();
    if (idioma == null) {
      await preferencias.remove(_chavePreferenciaIdioma);
    } else {
      await preferencias.setString(_chavePreferenciaIdioma, idioma.languageCode);
    }
  }
}

final idiomaSelecionadoProvider =
    NotifierProvider<IdiomaSelecionadoNotifier, Locale?>(
      IdiomaSelecionadoNotifier.new,
    );
