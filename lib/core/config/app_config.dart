class AppConfig {
  AppConfig._();

  static const String apiKey = String.fromEnvironment('GOOGLE_PLACES_API_KEY');
  static const String adUnitIdIos = String.fromEnvironment(
    'GOOGLE_AD_UNIT_ID_IOS',
  );
  static const String adUnitIdIAndroid = String.fromEnvironment(
    'GOOGLE_AD_UNIT_ID_ANDROID',
  );
  static const bool fullFeatureEnabled = bool.fromEnvironment(
    'FULL_FEATURE_ENABLED',
  );
}
