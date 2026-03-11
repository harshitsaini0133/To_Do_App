import 'package:to_do_app/core/config/app_config.dart';

class FirebaseConfig {
  const FirebaseConfig._();

  static String get apiKey => AppConfig.firebaseApiKey;
  static String get databaseUrl => AppConfig.firebaseDatabaseUrl;
}
