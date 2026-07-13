import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Control de Facturas'**
  String get appTitle;

  /// No description provided for @cancelButton.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get saveButton;

  /// No description provided for @deleteButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get deleteButton;

  /// No description provided for @errorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error. Intenta de nuevo.'**
  String get errorGeneric;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @emailRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el correo electrónico'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa la contraseña'**
  String get passwordRequired;

  /// No description provided for @loginError.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña inválidos'**
  String get loginError;

  /// No description provided for @homeTitle.
  ///
  /// In es, this message translates to:
  /// **'Control de Facturas'**
  String get homeTitle;

  /// No description provided for @entradaLabel.
  ///
  /// In es, this message translates to:
  /// **'Entrada'**
  String get entradaLabel;

  /// No description provided for @saidaLabel.
  ///
  /// In es, this message translates to:
  /// **'Salida'**
  String get saidaLabel;

  /// No description provided for @differenceLabel.
  ///
  /// In es, this message translates to:
  /// **'Diferencia'**
  String get differenceLabel;

  /// No description provided for @ivaLabel.
  ///
  /// In es, this message translates to:
  /// **'Total de IVA (10%)'**
  String get ivaLabel;

  /// No description provided for @addEntradaButton.
  ///
  /// In es, this message translates to:
  /// **'Entrada'**
  String get addEntradaButton;

  /// No description provided for @addSaidaButton.
  ///
  /// In es, this message translates to:
  /// **'Salida'**
  String get addSaidaButton;

  /// No description provided for @viewAllButton.
  ///
  /// In es, this message translates to:
  /// **'Ver todo'**
  String get viewAllButton;

  /// No description provided for @noInvoicesForMonth.
  ///
  /// In es, this message translates to:
  /// **'No hay facturas en este mes'**
  String get noInvoicesForMonth;

  /// No description provided for @webBannerDaysLeft.
  ///
  /// In es, this message translates to:
  /// **'Faltan 3 días para el vencimiento de las facturas del mes anterior'**
  String get webBannerDaysLeft;

  /// No description provided for @webBannerTomorrow.
  ///
  /// In es, this message translates to:
  /// **'Mañana es el último día para regularizar las facturas del mes anterior'**
  String get webBannerTomorrow;

  /// No description provided for @webBannerToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy es el último día para ajustar las facturas del mes anterior'**
  String get webBannerToday;

  /// No description provided for @newEntradaTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva entrada'**
  String get newEntradaTitle;

  /// No description provided for @newSaidaTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva salida'**
  String get newSaidaTitle;

  /// No description provided for @editInvoiceTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar factura'**
  String get editInvoiceTitle;

  /// No description provided for @amountLabel.
  ///
  /// In es, this message translates to:
  /// **'Valor'**
  String get amountLabel;

  /// No description provided for @amountRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el valor'**
  String get amountRequired;

  /// No description provided for @amountInvalid.
  ///
  /// In es, this message translates to:
  /// **'Valor inválido'**
  String get amountInvalid;

  /// No description provided for @dateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get dateLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la empresa o persona'**
  String get descriptionHint;

  /// No description provided for @descriptionRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa una descripción'**
  String get descriptionRequired;

  /// No description provided for @photoLabel.
  ///
  /// In es, this message translates to:
  /// **'Foto'**
  String get photoLabel;

  /// No description provided for @addPhotoButton.
  ///
  /// In es, this message translates to:
  /// **'Agregar foto'**
  String get addPhotoButton;

  /// No description provided for @changePhotoButton.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto'**
  String get changePhotoButton;

  /// No description provided for @removePhotoButton.
  ///
  /// In es, this message translates to:
  /// **'Quitar foto'**
  String get removePhotoButton;

  /// No description provided for @takePhotoOption.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get takePhotoOption;

  /// No description provided for @pickFromGalleryOption.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get pickFromGalleryOption;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar factura?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer.'**
  String get deleteConfirmMessage;

  /// No description provided for @allInvoicesTitle.
  ///
  /// In es, this message translates to:
  /// **'Facturas de {month}'**
  String allInvoicesTitle(String month);

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settingsTitle;

  /// No description provided for @dueDayLabel.
  ///
  /// In es, this message translates to:
  /// **'Día de vencimiento'**
  String get dueDayLabel;

  /// No description provided for @dueDayHelper.
  ///
  /// In es, this message translates to:
  /// **'Día del mes límite para regularizar las facturas del mes anterior'**
  String get dueDayHelper;

  /// No description provided for @languageLabel.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageLabel;

  /// No description provided for @portugueseOption.
  ///
  /// In es, this message translates to:
  /// **'Português'**
  String get portugueseOption;

  /// No description provided for @spanishOption.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanishOption;

  /// No description provided for @logoutButton.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logoutButton;

  /// No description provided for @adminShortcut.
  ///
  /// In es, this message translates to:
  /// **'Administración'**
  String get adminShortcut;

  /// No description provided for @adminTitle.
  ///
  /// In es, this message translates to:
  /// **'Administración'**
  String get adminTitle;

  /// No description provided for @usersListTitle.
  ///
  /// In es, this message translates to:
  /// **'Usuarios'**
  String get usersListTitle;

  /// No description provided for @createUserButton.
  ///
  /// In es, this message translates to:
  /// **'Crear usuario'**
  String get createUserButton;

  /// No description provided for @removeUserButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get removeUserButton;

  /// No description provided for @removeUserConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar usuario?'**
  String get removeUserConfirmTitle;

  /// No description provided for @removeUserConfirmMessage.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer.'**
  String get removeUserConfirmMessage;

  /// No description provided for @newUserEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo del nuevo usuario'**
  String get newUserEmailLabel;

  /// No description provided for @newUserPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña temporal'**
  String get newUserPasswordLabel;

  /// No description provided for @createButton.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get createButton;

  /// No description provided for @cannotRemoveSelf.
  ///
  /// In es, this message translates to:
  /// **'No puedes eliminar tu propia cuenta'**
  String get cannotRemoveSelf;

  /// No description provided for @adminBadge.
  ///
  /// In es, this message translates to:
  /// **'Admin'**
  String get adminBadge;

  /// No description provided for @notificationDueSoonTitle.
  ///
  /// In es, this message translates to:
  /// **'Vencimiento se acerca'**
  String get notificationDueSoonTitle;

  /// No description provided for @notificationDueSoonBody.
  ///
  /// In es, this message translates to:
  /// **'Faltan 3 días para el vencimiento de las facturas del mes anterior'**
  String get notificationDueSoonBody;

  /// No description provided for @notificationDueTomorrowTitle.
  ///
  /// In es, this message translates to:
  /// **'Último día es mañana'**
  String get notificationDueTomorrowTitle;

  /// No description provided for @notificationDueTomorrowBody.
  ///
  /// In es, this message translates to:
  /// **'Mañana es el último día para regularizar las facturas del mes anterior'**
  String get notificationDueTomorrowBody;

  /// No description provided for @notificationDueTodayTitle.
  ///
  /// In es, this message translates to:
  /// **'Último día es hoy'**
  String get notificationDueTodayTitle;

  /// No description provided for @notificationDueTodayBody.
  ///
  /// In es, this message translates to:
  /// **'Hoy es el último día para ajustar las facturas del mes anterior'**
  String get notificationDueTodayBody;

  /// No description provided for @changePasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordMenuLabel.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get changePasswordMenuLabel;

  /// No description provided for @mandatoryPasswordChangeMessage.
  ///
  /// In es, this message translates to:
  /// **'Por seguridad, definí una nueva contraseña antes de continuar.'**
  String get mandatoryPasswordChangeMessage;

  /// No description provided for @newPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Nueva contraseña'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordTooShort.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres'**
  String get passwordTooShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordMismatch;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
