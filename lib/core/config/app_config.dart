class AppConfig {
  AppConfig._();

  static const String apiKey = String.fromEnvironment('GOOGLE_PLACES_API_KEY');
  static const bool fullFeatureEnabled = bool.fromEnvironment(
    'FULL_FEATURE_ENABLED',
  );
}
