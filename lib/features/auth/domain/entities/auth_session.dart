import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.localId,
    required this.email,
    required this.idToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  final String localId;
  final String email;
  final String idToken;
  final String refreshToken;
  final DateTime expiresAt;

  bool get isExpired =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(seconds: 30)));

  String get displayName {
    final rawName = email.split('@').first.replaceAll(RegExp(r'[._-]+'), ' ');
    return rawName
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .map(
          (part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  @override
  List<Object?> get props => [
        localId,
        email,
        idToken,
        refreshToken,
        expiresAt,
      ];
}
