import 'package:injectable/injectable.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> loginWithUsername({
    required String username,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  });

  Future<void> logout();

  Future<AuthTokensModel> refreshTokens(String refreshToken);

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
  });

  Future<void> verifyEmail(String token);

  Future<void> resendEmailVerification();

  Future<void> deleteAccount(String password);

  Future<bool> checkEmailExists(String email);

  Future<bool> checkUsernameExists(String username);

  Future<UserModel> getUserById(int userId);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: {
          'username': email, // Fake Store API uses username field
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'] as String;

        // Get user data (Fake Store API doesn't return user in login response)
        final userResponse = await _dioClient.get(
          '${ApiConstants.users}/1', // Mock user ID for demo
        );

        if (userResponse.statusCode == 200) {
          final userData = userResponse.data as Map<String, dynamic>;
          userData['token'] = token; // Add token to user data
          return UserModel.fromJson(userData);
        }
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Login failed: ${e.toString()}',
        code: 'LOGIN_ERROR',
      );
    }
  }

  @override
  Future<UserModel> loginWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'] as String;

        // Get user data
        final userResponse = await _dioClient.get(
          '${ApiConstants.users}/1',
        );

        if (userResponse.statusCode == 200) {
          final userData = userResponse.data as Map<String, dynamic>;
          userData['token'] = token;
          return UserModel.fromJson(userData);
        }
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Login failed: ${e.toString()}',
        code: 'LOGIN_ERROR',
      );
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.users,
        data: {
          'email': email,
          'username': username,
          'password': password,
          'name': {
            'firstname': firstName,
            'lastname': lastName,
          },
          'address': {
            'city': 'kilcoole',
            'street': '7835 new road',
            'number': 3,
            'zipcode': '12926-3874',
            'geolocation': {
              'lat': '-37.3159',
              'long': '81.1496'
            }
          },
          'phone': phone ?? '1-570-236-7033',
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Registration failed: ${e.toString()}',
        code: 'REGISTER_ERROR',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Fake Store API doesn't have logout endpoint
      // In real app, you would call logout endpoint here
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw NetworkException(
        message: 'Logout failed: ${e.toString()}',
        code: 'LOGOUT_ERROR',
      );
    }
  }

  @override
  Future<AuthTokensModel> refreshTokens(String refreshToken) async {
    try {
      // Fake Store API doesn't support token refresh
      // In real app, you would call refresh endpoint here
      await Future.delayed(const Duration(milliseconds: 500));

      // Return mock token
      return AuthTokensModel(
        accessToken: 'new_mock_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: refreshToken,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        tokenType: 'Bearer',
      );
    } catch (e) {
      throw NetworkException(
        message: 'Token refresh failed: ${e.toString()}',
        code: 'TOKEN_REFRESH_ERROR',
      );
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      // Mock implementation for Fake Store API
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw NetworkException(
        message: 'Forgot password failed: ${e.toString()}',
        code: 'FORGOT_PASSWORD_ERROR',
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw NetworkException(
        message: 'Reset password failed: ${e.toString()}',
        code: 'RESET_PASSWORD_ERROR',
      );
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw NetworkException(
        message: 'Change password failed: ${e.toString()}',
        code: 'CHANGE_PASSWORD_ERROR',
      );
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
  }) async {
    try {
      final response = await _dioClient.put(
        '${ApiConstants.users}/1',
        data: {
          if (firstName != null) 'name.firstname': firstName,
          if (lastName != null) 'name.lastname': lastName,
          if (phone != null) 'phone': phone,
          if (avatar != null) 'avatar': avatar,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Update profile failed: ${e.toString()}',
        code: 'UPDATE_PROFILE_ERROR',
      );
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw NetworkException(
        message: 'Email verification failed: ${e.toString()}',
        code: 'EMAIL_VERIFICATION_ERROR',
      );
    }
  }

  @override
  Future<void> resendEmailVerification() async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw NetworkException(
        message: 'Resend verification failed: ${e.toString()}',
        code: 'RESEND_VERIFICATION_ERROR',
      );
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      final response = await _dioClient.delete(
        '${ApiConstants.users}/1',
        data: {'password': password},
      );

      if (response.statusCode != 200) {
        throw ApiException.fromResponse(
          response.statusCode ?? 500,
          response.data,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Delete account failed: ${e.toString()}',
        code: 'DELETE_ACCOUNT_ERROR',
      );
    }
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      // Mock implementation - in real app, you'd have a dedicated endpoint
      final response = await _dioClient.get(ApiConstants.users);

      if (response.statusCode == 200) {
        final users = response.data as List;
        return users.any((user) => user['email'] == email);
      }

      return false;
    } catch (e) {
      throw NetworkException(
        message: 'Check email failed: ${e.toString()}',
        code: 'CHECK_EMAIL_ERROR',
      );
    }
  }

  @override
  Future<bool> checkUsernameExists(String username) async {
    try {
      // Mock implementation
      final response = await _dioClient.get(ApiConstants.users);

      if (response.statusCode == 200) {
        final users = response.data as List;
        return users.any((user) => user['username'] == username);
      }

      return false;
    } catch (e) {
      throw NetworkException(
        message: 'Check username failed: ${e.toString()}',
        code: 'CHECK_USERNAME_ERROR',
      );
    }
  }

  @override
  Future<UserModel> getUserById(int userId) async {
    try {
      final response = await _dioClient.get('${ApiConstants.users}/$userId');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Get user failed: ${e.toString()}',
        code: 'GET_USER_ERROR',
      );
    }
  }
}