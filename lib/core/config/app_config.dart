class AppConfig {
  const AppConfig._();

  static const String firebaseApiKey = String.fromEnvironment(
    'AIzaSyBm3_iGwHRMIaFMj4H_aW5Zj2xX9UNR4uw',
    defaultValue: 'AIzaSyBm3_iGwHRMIaFMj4H_aW5Zj2xX9UNR4uw',
  );

  static const String firebaseDatabaseUrl = String.fromEnvironment(
    'https://bookzila-3147b-default-rtdb.firebaseio.com',
    defaultValue: 'https://bookzila-3147b-default-rtdb.firebaseio.com',
  );
  static bool get isFirebaseConfigured =>
      firebaseApiKey.isNotEmpty && firebaseDatabaseUrl.isNotEmpty;

  static List<String> get missingConfiguration {
    final missing = <String>[];
    if (firebaseApiKey.isEmpty) {
      missing.add('FIREBASE_API_KEY');
    }
    if (firebaseDatabaseUrl.isEmpty) {
      missing.add('FIREBASE_DATABASE_URL');
    }
    return missing;
  }
}
