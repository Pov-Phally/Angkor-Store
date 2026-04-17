import 'dart:convert';

import 'package:angkor_store/core/errors/exceptions.dart';
import 'package:angkor_store/core/models/user_model.dart';
import 'package:angkor_store/core/utils/constants/network_constant.dart';
import 'package:angkor_store/core/utils/error_response.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
        body: {"email": email},
      );
      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
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
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<void> verifyOTP({required String email, required String otp}) async {
    // TODO: implement verifyOTP
    throw UnimplementedError();
  }

  @override
  Future<bool> verifyToken() async {
    // TODO: implement verifyToken
    throw UnimplementedError();
  }
}
