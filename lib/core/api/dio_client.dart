import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:to_do_app/core/api/connectivity_interceptor.dart';

class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            validateStatus: (status) => status != null && status < 500,
          ),
        ) {
    _dio.interceptors.add(ConnectivityInterceptor());
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }
  }

  final Dio _dio;

  Future<Response<T>> getUri<T>(Uri uri, {Options? options}) {
    return _dio.getUri<T>(uri, options: options);
  }

  Future<Response<T>> postUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
  }) {
    return _dio.postUri<T>(uri, data: data, options: options);
  }

  Future<Response<T>> patchUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
  }) {
    return _dio.patchUri<T>(uri, data: data, options: options);
  }

  Future<Response<T>> deleteUri<T>(
    Uri uri, {
    Object? data,
    Options? options,
  }) {
    return _dio.deleteUri<T>(uri, data: data, options: options);
  }
}
