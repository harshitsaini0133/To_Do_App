import 'dart:convert';

import 'package:to_do_app/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.localId,
    required super.email,
    required super.idToken,
    required super.refreshToken,
    required super.expiresAt,
  });

  factory AuthSessionModel.fromAuthJson(Map<String, dynamic> json) {
    final expiresInSeconds = int.tryParse(json['expiresIn'].toString()) ?? 3600;
    return AuthSessionModel(
      localId: json['localId'] as String,
      email: json['email'] as String,
      idToken: json['idToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.now().add(Duration(seconds: expiresInSeconds)),
    );
  }

  factory AuthSessionModel.fromRefreshJson(
    Map<String, dynamic> json, {
    required AuthSession previous,
  }) {
    final expiresInSeconds =
        int.tryParse(json['expires_in']?.toString() ?? '') ?? 3600;
    return AuthSessionModel(
      localId: json['user_id']?.toString() ?? previous.localId,
      email: previous.email,
      idToken: json['id_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: DateTime.now().add(Duration(seconds: expiresInSeconds)),
    );
  }

  factory AuthSessionModel.fromStorageJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      localId: json['localId'] as String,
      email: json['email'] as String,
      idToken: json['idToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  factory AuthSessionModel.fromStorageString(String value) {
    return AuthSessionModel.fromStorageJson(
      jsonDecode(value) as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'localId': localId,
      'email': email,
      'idToken': idToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  String toStorageString() => jsonEncode(toStorageJson());
}
