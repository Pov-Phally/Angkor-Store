import 'dart:convert';

import 'package:angkor_store/core/common/app/cache_helper.dart';
import 'package:angkor_store/core/errors/exceptions.dart';
import 'package:angkor_store/core/models/user_model.dart';
import 'package:angkor_store/core/services/injection_container.dart';
import 'package:angkor_store/core/utils/constants/network_constant.dart';
import 'package:angkor_store/core/utils/error_response.dart';
import 'package:angkor_store/core/utils/network_utils.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/common/singletons/cache.dart';
import '../../../../core/extensions/string_extension.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<UserModel> login({required String email, required String password});

  Future<void> forgotPassword({required String email});

  Future<void> verifyOTP({required String email, required String otp});

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<bool> verifyToken();

  Future<void> logout();
}

const registerEndPoint = "/auth/register";
const loginEndPoint = "/auth/login";
const forgotPasswordEndPoint = "/auth/forgot-password";
const verifyOTPEndPoint = "/auth/verify-otp";
const resetPasswordEndPoint = "/auth/reset-password";
const verifyTokenEndPoint = "/auth/verify-token";
const logoutEndPoint = "/auth/logout";

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final uri = Uri.parse(
        "${NetworkConstant.baseUrl}$forgotPasswordEndPoint",
      );
      final response = await _client.post(
        uri,
        headers: NetworkConstant.header,
        body: jsonEncode({"email": email}),
      );
      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse("${NetworkConstant.baseUrl}$loginEndPoint");
      final response = await _client.post(
        uri,
        headers: NetworkConstant.header,
        body: jsonEncode({"email": email, "password": password}),
      );
      final payload = jsonDecode(response.body) as DataMap;
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      await serviceLocater<CacheHelper>().cacheSessionToken(
        payload['accessToken'],
      );
      final user = UserModel.fromMap(payload);
      await serviceLocater<CacheHelper>().cacheUserId(user.id);
      return user;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final uri = Uri.parse("${NetworkConstant.baseUrl}$registerEndPoint");
      final response = await _client.post(
        uri,
        headers: NetworkConstant.header,
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
        }),
      );
      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final uri = Uri.parse("${NetworkConstant.baseUrl}$resetPasswordEndPoint");
      final response = await _client.post(
        uri,
        headers: NetworkConstant.header,
        body: jsonEncode({"email": email, "newPassword": newPassword}),
      );
      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> verifyOTP({required String email, required String otp}) async {
    try {
      final uri = Uri.parse("${NetworkConstant.baseUrl}$verifyOTPEndPoint");
      final response = await _client.post(
        uri,
        headers: NetworkConstant.header,
        body: jsonEncode({"email": email, "otp": otp}),
      );
      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<bool> verifyToken() async {
    try {
      final uri = Uri.parse("${NetworkConstant.baseUrl}$verifyTokenEndPoint");
      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        payload as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return payload as bool;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final uri = Uri.parse("${NetworkConstant.baseUrl}$logoutEndPoint");
      final response = await _client.post(uri, headers: NetworkConstant.header);
      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
