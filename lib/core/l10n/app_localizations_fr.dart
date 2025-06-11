// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get title => 'RedFlags';

  @override
  String get checkLoading => 'Vérification des données en cours';

  @override
  String get checkSuccess => 'Chargement terminé!';

  @override
  String get errorFailure => 'Une erreur interne s\'est produite';

  @override
  String get errorNetwork => 'Une erreur s\'est produite avec le serveur';

  @override
  String get errorUnknown =>
      'Une erreur d\'origine inconnu s\'est produite sur l\'application';

  @override
  String get accessButton => 'Accéder';

  @override
  String get searchButton => 'Rechercher';

  @override
  String get okButton => 'Ok';

  @override
  String get nextButton => 'Suivant';

  @override
  String get backButton => 'Retour';

  @override
  String get previousButton => 'Précédent';

  @override
  String get createButton => 'Créer';

  @override
  String get personCreationSuccess => 'Personne ajoutée avec succès.';

  @override
  String get createScreenTitle => 'Ajout';

  @override
  String get createScreenSubTitle => 'Ajoute un potenciel redflag';

  @override
  String get homeAddOption => 'Ajouter';

  @override
  String get homeSearchOption => 'Rechercher';

  @override
  String get homeNews => 'News';

  @override
  String get homeDatabase => 'Database';

  @override
  String get homeOptions => 'Options';

  @override
  String get descriptionTitle => 'Description';

  @override
  String get homeScreenTitle => 'Red Flags';

  @override
  String get homeScreenSubTitle => '';

  @override
  String get searchScreenTitle => 'Recherche';

  @override
  String get searchScreenSubTitle => 'Par nom, prénom…';

  @override
  String get personListViewScreenTitle => 'Résultats';

  @override
  String get personListViewScreenSubTitle => 'Personnes Trouvées';

  @override
  String get lastname => 'Nom';

  @override
  String get firstname => 'Prénom';

  @override
  String get birthDate => 'Date de Naissance';

  @override
  String get zoneName => 'Ville/Région actuelle';

  @override
  String get companyName => 'Entreprise/société';

  @override
  String get activityName => 'Métier/Activité';

  @override
  String get personDuplicationError =>
      'Cette personne semble déjà exister dans notre base de données.';
}
