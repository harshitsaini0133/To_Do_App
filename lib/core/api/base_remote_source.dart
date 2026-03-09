import 'package:dio/dio.dart';
import 'package:to_do_app/core/api/api_error.dart';
import 'package:to_do_app/core/api/dio_client.dart';

typedef JsonParser<T> = T Function(dynamic json);

abstract class BaseRemoteSource {
  const BaseRemoteSource(this.client);

  final DioClient client;

  Future<T> guard<T>({
    required Future<Response<dynamic>> Function() request,
    required JsonParser<T> parser,
  }) async {
    try {
      final response = await request();
      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        return parser(response.data);
      }
      throw ApiError.fromResponse(response);
    } on DioException catch (error) {
      throw ApiError.fromDio(error);
    } on ApiError {
      rethrow;
    } catch (error) {
      throw ApiError(
        message: error.toString(),
        type: ApiErrorType.unknown,
      );
    }
  }
}
