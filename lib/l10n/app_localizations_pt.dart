// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Controle de Faturas';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get saveButton => 'Salvar';

  @override
  String get deleteButton => 'Excluir';

  @override
  String get errorGeneric => 'Ocorreu um erro. Tente novamente.';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get emailRequired => 'Informe o e-mail';

  @override
  String get passwordRequired => 'Informe a senha';

  @override
  String get loginError => 'E-mail ou senha inválidos';

  @override
  String get homeTitle => 'Controle de Faturas';

  @override
  String get entradaLabel => 'Entrada';

  @override
  String get saidaLabel => 'Saída';

  @override
  String get differenceLabel => 'Diferença';

  @override
  String get addEntradaButton => 'Entrada';

  @override
  String get addSaidaButton => 'Saída';

  @override
  String get viewAllButton => 'Ver tudo';

  @override
  String get noInvoicesForMonth => 'Nenhuma fatura neste mês';

  @override
  String get webBannerDaysLeft =>
      'Faltam 3 dias para o vencimento das faturas do mês anterior';

  @override
  String get webBannerTomorrow =>
      'Amanhã é o último dia para regularizar as faturas do mês anterior';

  @override
  String get webBannerToday =>
      'Hoje é o último dia para ajustar as faturas do mês anterior';

  @override
  String get newEntradaTitle => 'Nova entrada';

  @override
  String get newSaidaTitle => 'Nova saída';

  @override
  String get editInvoiceTitle => 'Editar fatura';

  @override
  String get amountLabel => 'Valor';

  @override
  String get amountRequired => 'Informe o valor';

  @override
  String get amountInvalid => 'Valor inválido';

  @override
  String get dateLabel => 'Data';

  @override
  String get descriptionLabel => 'Descrição';

  @override
  String get descriptionHint => 'Nome da empresa ou pessoa';

  @override
  String get descriptionRequired => 'Informe uma descrição';

  @override
  String get photoLabel => 'Foto';

  @override
  String get addPhotoButton => 'Adicionar foto';

  @override
  String get changePhotoButton => 'Trocar foto';

  @override
  String get removePhotoButton => 'Remover foto';

  @override
  String get takePhotoOption => 'Câmera';

  @override
  String get pickFromGalleryOption => 'Galeria';

  @override
  String get deleteConfirmTitle => 'Excluir fatura?';

  @override
  String get deleteConfirmMessage => 'Esta ação não pode ser desfeita.';

  @override
  String allInvoicesTitle(String month) {
    return 'Faturas de $month';
  }

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get dueDayLabel => 'Dia de vencimento';

  @override
  String get dueDayHelper =>
      'Dia limite do mês para regularizar as faturas do mês anterior';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get portugueseOption => 'Português';

  @override
  String get spanishOption => 'Español';

  @override
  String get logoutButton => 'Sair';

  @override
  String get adminShortcut => 'Administração';

  @override
  String get adminTitle => 'Administração';

  @override
  String get usersListTitle => 'Usuários';

  @override
  String get createUserButton => 'Criar usuário';

  @override
  String get removeUserButton => 'Remover';

  @override
  String get removeUserConfirmTitle => 'Remover usuário?';

  @override
  String get removeUserConfirmMessage => 'Esta ação não pode ser desfeita.';

  @override
  String get newUserEmailLabel => 'E-mail do novo usuário';

  @override
  String get newUserPasswordLabel => 'Senha temporária';

  @override
  String get createButton => 'Criar';

  @override
  String get cannotRemoveSelf => 'Você não pode remover sua própria conta';

  @override
  String get adminBadge => 'Admin';

  @override
  String get notificationDueSoonTitle => 'Vencimento se aproxima';

  @override
  String get notificationDueSoonBody =>
      'Faltam 3 dias para o vencimento das faturas do mês anterior';

  @override
  String get notificationDueTomorrowTitle => 'Último dia é amanhã';

  @override
  String get notificationDueTomorrowBody =>
      'Amanhã é o último dia para regularizar as faturas do mês anterior';

  @override
  String get notificationDueTodayTitle => 'Último dia é hoje';

  @override
  String get notificationDueTodayBody =>
      'Hoje é o último dia para ajustar as faturas do mês anterior';
}
