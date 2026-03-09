import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await Connectivity().checkConnectivity();
    final isOffline = result.length == 1 && result.contains(ConnectivityResult.none);

    if (isOffline) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet connection',
        ),
      );
      return;
    }

    handler.next(options);
  }
}
