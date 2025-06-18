import '../../domain/entities/auth_tokens.dart';

class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    super.refreshToken,
    required super.expiresAt,
    super.tokenType,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    // Handle different API response formats
    final accessToken = json['token'] ?? json['access_token'] ?? json['accessToken'];
    final refreshToken = json['refresh_token'] ?? json['refreshToken'];
    final tokenType = json['token_type'] ?? json['tokenType'] ?? 'Bearer';

    // Calculate expiry time
    DateTime expiresAt;
    if (json.containsKey('expires_at')) {
      expiresAt = DateTime.parse(json['expires_at'] as String);
    } else if (json.containsKey('expiresAt')) {
      expiresAt = DateTime.parse(json['expiresAt'] as String);
    } else if (json.containsKey('expires_in')) {
      final expiresIn = json['expires_in'] as int;
      expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    } else {
      // Default to 1 hour if no expiry specified
      expiresAt = DateTime.now().add(const Duration(hours: 1));
    }

    return AuthTokensModel(
      accessToken: accessToken as String,
      refreshToken: refreshToken as String?,
      expiresAt: expiresAt,
      tokenType: tokenType as String,
    );
  }

  // Manual toJson implementation
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
      'token_type': tokenType,
    };
  }

  factory AuthTokensModel.fromAuthTokens(AuthTokens tokens) {
    return AuthTokensModel(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresAt: tokens.expiresAt,
      tokenType: tokens.tokenType,
    );
  }

  AuthTokensModel copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? tokenType,
  }) {
    return AuthTokensModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      tokenType: tokenType ?? this.tokenType,
    );
  }
}