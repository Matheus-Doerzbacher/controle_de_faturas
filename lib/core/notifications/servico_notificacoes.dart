import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../l10n/app_localizations.dart';

/// Agenda os 3 lembretes mensais de vencimento (mobile only — no Web o
/// aviso é o banner dentro do app, ver `banner_lembrete_web.dart`).
///
/// Usa `matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime`, que
/// faz o próprio plugin recriar a ocorrência do mês seguinte a cada disparo,
/// sem precisar de nenhum reagendamento manual mês a mês.
class ServicoNotificacoes {
  ServicoNotificacoes._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _idCanal = 'lembretes_vencimento';
  static const String _nomeCanal = 'Lembretes de vencimento';
  static const String _descricaoCanal =
      'Avisos sobre o prazo para regularizar as faturas do mês anterior';
  static const int _horaLembrete = 9;

  static bool _inicializado = false;

  static Future<void> inicializar() async {
    if (kIsWeb || _inicializado) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Asuncion'));

    const configuracoes = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings: configuracoes);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    const canal = AndroidNotificationChannel(
      _idCanal,
      _nomeCanal,
      description: _descricaoCanal,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(canal);

    _inicializado = true;
  }

  /// Cancela e recria os 3 lembretes. Deve ser chamado na abertura do app
  /// (após carregar o perfil), e sempre que o dia de vencimento ou o idioma
  /// mudarem nas Configurações — o texto é fixado no momento do agendamento,
  /// não do disparo.
  static Future<void> reagendarLembretes({
    required int diaVencimento,
    required String localeCode,
  }) async {
    if (kIsWeb) return;
    await inicializar();

    await _plugin.cancelAll();

    final textos = await AppLocalizations.delegate.load(Locale(localeCode));

    await _agendar(
      id: 1,
      dia: diaVencimento - 3,
      titulo: textos.notificationDueSoonTitle,
      corpo: textos.notificationDueSoonBody,
    );
    await _agendar(
      id: 2,
      dia: diaVencimento - 2,
      titulo: textos.notificationDueTomorrowTitle,
      corpo: textos.notificationDueTomorrowBody,
    );
    await _agendar(
      id: 3,
      dia: diaVencimento - 1,
      titulo: textos.notificationDueTodayTitle,
      corpo: textos.notificationDueTodayBody,
    );
  }

  static Future<void> _agendar({
    required int id,
    required int dia,
    required String titulo,
    required String corpo,
  }) async {
    const detalhes = NotificationDetails(
      android: AndroidNotificationDetails(
        _idCanal,
        _nomeCanal,
        channelDescription: _descricaoCanal,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id: id,
      title: titulo,
      body: corpo,
      scheduledDate: _proximaOcorrencia(dia),
      notificationDetails: detalhes,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  static tz.TZDateTime _proximaOcorrencia(int dia) {
    final agora = tz.TZDateTime.now(tz.local);
    var data = tz.TZDateTime(
      tz.local,
      agora.year,
      agora.month,
      dia,
      _horaLembrete,
    );
    if (data.isBefore(agora)) {
      final proximoMes = agora.month == 12 ? 1 : agora.month + 1;
      final proximoAno = agora.month == 12 ? agora.year + 1 : agora.year;
      data = tz.TZDateTime(
        tz.local,
        proximoAno,
        proximoMes,
        dia,
        _horaLembrete,
      );
    }
    return data;
  }
}
