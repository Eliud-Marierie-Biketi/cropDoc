// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ZaoDoc';

  @override
  String get loadingMessage => 'Loading ZaoDoc...';

  @override
  String get welcomeTitle => 'Welcome!';

  @override
  String get welcomeDescription => 'ZaoDoc helps you detect maize diseases using your camera or gallery and get treatment suggestions offline.';

  @override
  String get continueButton => 'Continue';

  @override
  String get registerTitle => 'Register';

  @override
  String get countryLabel => 'Country';

  @override
  String get countyLabel => 'County';

  @override
  String get otherLabel => 'Other';

  @override
  String get nameLabel => 'Name';

  @override
  String get roleLabel => 'Role';

  @override
  String get consentText => 'I consent to store my registration info';

  @override
  String get registerButton => 'Finish';

  @override
  String get completeFormMessage => 'Please complete the form and give consent';

  @override
  String get farmer => 'Farmer';

  @override
  String get extensionOfficer => 'Extension Officer';

  @override
  String get researcher => 'Researcher';

  @override
  String get scanTab => 'Scan';

  @override
  String get takePicture => 'Take Picture';

  @override
  String get samplesTab => 'Samples';

  @override
  String get historyTab => 'History';

  @override
  String get profileTab => 'Profile';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get cropLabel => 'Crop';

  @override
  String get maize => 'Maize';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get analyze => 'Analyze';

  @override
  String get profileSaved => 'Profile saved successfully!';

  @override
  String get profileDetails => 'Profile Details';

  @override
  String get processing => 'processing';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get diseaseDetection => 'Disease Detection';

  @override
  String get diseaseDetectionDesc => ' Use the camera to capture an image of the maize plant to detect diseases.';

  @override
  String get cropManagement => 'Crop Management';

  @override
  String get cropManagementDesc => 'Access resources and tips for effective maize crop management.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get themeLabel => 'Theme';

  @override
  String get logoutButton => 'Clear Data / Logout';

  @override
  String get results => 'Results';

  @override
  String get sampleImages => 'Sample Images';
}
