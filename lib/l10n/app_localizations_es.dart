// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Control de Facturas';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get saveButton => 'Guardar';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String get errorGeneric => 'Ocurrió un error. Intenta de nuevo.';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get loginButton => 'Entrar';

  @override
  String get emailRequired => 'Ingresa el correo electrónico';

  @override
  String get passwordRequired => 'Ingresa la contraseña';

  @override
  String get loginError => 'Correo o contraseña inválidos';

  @override
  String get homeTitle => 'Control de Facturas';

  @override
  String get entradaLabel => 'Entrada';

  @override
  String get saidaLabel => 'Salida';

  @override
  String get differenceLabel => 'Diferencia';

  @override
  String get addEntradaButton => 'Entrada';

  @override
  String get addSaidaButton => 'Salida';

  @override
  String get viewAllButton => 'Ver todo';

  @override
  String get noInvoicesForMonth => 'No hay facturas en este mes';

  @override
  String get webBannerDaysLeft =>
      'Faltan 3 días para el vencimiento de las facturas del mes anterior';

  @override
  String get webBannerTomorrow =>
      'Mañana es el último día para regularizar las facturas del mes anterior';

  @override
  String get webBannerToday =>
      'Hoy es el último día para ajustar las facturas del mes anterior';

  @override
  String get newEntradaTitle => 'Nueva entrada';

  @override
  String get newSaidaTitle => 'Nueva salida';

  @override
  String get editInvoiceTitle => 'Editar factura';

  @override
  String get amountLabel => 'Valor';

  @override
  String get amountRequired => 'Ingresa el valor';

  @override
  String get amountInvalid => 'Valor inválido';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get descriptionHint => 'Nombre de la empresa o persona';

  @override
  String get descriptionRequired => 'Ingresa una descripción';

  @override
  String get photoLabel => 'Foto';

  @override
  String get addPhotoButton => 'Agregar foto';

  @override
  String get changePhotoButton => 'Cambiar foto';

  @override
  String get removePhotoButton => 'Quitar foto';

  @override
  String get takePhotoOption => 'Cámara';

  @override
  String get pickFromGalleryOption => 'Galería';

  @override
  String get deleteConfirmTitle => '¿Eliminar factura?';

  @override
  String get deleteConfirmMessage => 'Esta acción no se puede deshacer.';

  @override
  String allInvoicesTitle(String month) {
    return 'Facturas de $month';
  }

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get dueDayLabel => 'Día de vencimiento';

  @override
  String get dueDayHelper =>
      'Día del mes límite para regularizar las facturas del mes anterior';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get portugueseOption => 'Português';

  @override
  String get spanishOption => 'Español';

  @override
  String get logoutButton => 'Cerrar sesión';

  @override
  String get adminShortcut => 'Administración';

  @override
  String get adminTitle => 'Administración';

  @override
  String get usersListTitle => 'Usuarios';

  @override
  String get createUserButton => 'Crear usuario';

  @override
  String get removeUserButton => 'Eliminar';

  @override
  String get removeUserConfirmTitle => '¿Eliminar usuario?';

  @override
  String get removeUserConfirmMessage => 'Esta acción no se puede deshacer.';

  @override
  String get newUserEmailLabel => 'Correo del nuevo usuario';

  @override
  String get newUserPasswordLabel => 'Contraseña temporal';

  @override
  String get createButton => 'Crear';

  @override
  String get cannotRemoveSelf => 'No puedes eliminar tu propia cuenta';

  @override
  String get adminBadge => 'Admin';

  @override
  String get notificationDueSoonTitle => 'Vencimiento se acerca';

  @override
  String get notificationDueSoonBody =>
      'Faltan 3 días para el vencimiento de las facturas del mes anterior';

  @override
  String get notificationDueTomorrowTitle => 'Último día es mañana';

  @override
  String get notificationDueTomorrowBody =>
      'Mañana es el último día para regularizar las facturas del mes anterior';

  @override
  String get notificationDueTodayTitle => 'Último día es hoy';

  @override
  String get notificationDueTodayBody =>
      'Hoy es el último día para ajustar las facturas del mes anterior';
}
