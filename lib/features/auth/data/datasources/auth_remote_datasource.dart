import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokensModel> login({
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

  Future<UserModel> getUserById(int userId);
  Future<List<UserModel>> getAllUsers();
  Future<UserModel> updateUser(int userId, Map<String, dynamic> userData);
  Future<void> deleteUser(int userId);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthTokensModel> login({
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
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('token')) {
          return AuthTokensModel(
            accessToken: responseData['token'] as String,
            expiresAt: DateTime.now().add(const Duration(hours: 24)),
            tokenType: 'Bearer',
          );
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
      // Following the exact API documentation format
      final requestData = {
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
      };

      final response = await _dioClient.post(
        ApiConstants.users,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;

        // The API returns the created user with an ID
        // Example response: {"id": 11}
        if (responseData.containsKey('id')) {
          // Create a complete user model with the provided data
          final userModel = UserModel(
            id: responseData['id'] as int,
            email: email,
            username: username,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            isEmailVerified: false, // Default for new users
            isActive: true,
            createdAt: DateTime.now(),
            additionalData: {
              'address': requestData['address'],
            },
          );

          return userModel;
        } else {
          // Fallback: create user model with timestamp ID
          return UserModel(
            id: DateTime.now().millisecondsSinceEpoch,
            email: email,
            username: username,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            isEmailVerified: false,
            isActive: true,
            createdAt: DateTime.now(),
            additionalData: {
              'address': requestData['address'],
            },
          );
        }
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      // Handle specific registration errors
      if (e.toString().contains('400')) {
        throw AuthException(
          message: 'Registration failed. Please check your information and try again.',
          code: 'REGISTRATION_FAILED',
        );
      }

      throw NetworkException(
        message: 'Registration failed: ${e.toString()}',
        code: 'REGISTER_ERROR',
      );
    }
  }

  @override
  Future<UserModel> getUserById(int userId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.userById(userId),
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
        message: 'Get user failed: ${e.toString()}',
        code: 'GET_USER_ERROR',
      );
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _dioClient.get(ApiConstants.users);

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = response.data;
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Get users failed: ${e.toString()}',
        code: 'GET_USERS_ERROR',
      );
    }
  }

  @override
  Future<UserModel> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      final response = await _dioClient.put(
        ApiConstants.userById(userId),
        data: userData,
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
        message: 'Update user failed: ${e.toString()}',
        code: 'UPDATE_USER_ERROR',
      );
    }
  }

  @override
  Future<void> deleteUser(int userId) async {
    try {
      final response = await _dioClient.delete(
        ApiConstants.userById(userId),
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
        message: 'Delete user failed: ${e.toString()}',
        code: 'DELETE_USER_ERROR',
      );
    }
  }
}