// Flutter Packages
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Services
import 'parameters.dart';
import 'secure_storage.dart';

// ignore_for_file: constant_identifier_names
enum APIEnviroment { PROD, DESENV, LOCAL }

// Edited
const C_API_ACCESS_PROD = "prod";
const C_API_ACCESS_DESENV = "desenv";
const C_API_ACCESS_LOCAL = "local";

class DioProvider {
  final Dio _dio = Dio();

  // Persist Data
  final SecureStorage _storage = SecureStorage();

  Dio get dio => _dio;

  DioProvider() {
    BaseOptions defaultOptions = BaseOptions(
      baseUrl: baseUrlOnEnviroment(APIEnviroment.PROD),
      connectTimeout: Parameters.CONNECT_TIMEOUT,
      receiveTimeout: Parameters.RECEIVE_TIMEOUT,
      sendTimeout: Parameters.SEND_TIMEOUT,
      receiveDataWhenStatusError: true,
    );

    _dio.options = defaultOptions;

    // Interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (DioException error, handler) async => handler.next(error),
      ),
    );
  }

  String baseUrlOnEnviroment(APIEnviroment enviroment) {
    switch (enviroment) {
      case APIEnviroment.PROD:
        return C_API_ACCESS_PROD;
      case APIEnviroment.DESENV:
        return C_API_ACCESS_DESENV;
      case APIEnviroment.LOCAL:
        return C_API_ACCESS_LOCAL;
    }
  }
}

final dioProvider = Provider<DioProvider>((ref) => DioProvider());
