import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();

  static String get firebaseApiKey =>
      dotenv.get('FIREBASE_API_KEY', fallback: '');

  static String get firebaseDatabaseUrl =>
      dotenv.get('FIREBASE_DATABASE_URL', fallback: '');

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
