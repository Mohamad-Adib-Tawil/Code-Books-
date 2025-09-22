import 'dart:developer';
import 'package:code_books/core/errors/failure.dart';
import 'package:code_books/core/errors/retry.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class ApiServices {
  final Dio _dio;
  final String baseUrl = "https://www.googleapis.com/books/v1/";

  ApiServices(this._dio);

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    try {
      var response = await retry(
        () async {
          final response = await _dio.get('$baseUrl$endPoint');
          log('ApiServices response ::: $response');
          log('ApiServices response.data ::: ${response.data}');
          return response.data;
        },
        retries: 3,
        delay: const Duration(seconds: 1),
      );

      return response;
    } on DioException catch (e) {
      log('ApiServices errorDioException ::: $e');
      throw ServerFailure.fromDioException(e);
    } catch (e) {
      log('ApiServices error ::: $e');
      throw ServerFailure(e.toString());
    }
  }
}
