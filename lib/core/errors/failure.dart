import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  Failure( this.message);
}

class ServerFailure extends Failure {
  ServerFailure( super.message);
  factory ServerFailure.fromDioException(DioException e) {
    switch (e.error) {
      case DioException.connectionError:
        return ServerFailure( 'connectionError Error');
      case DioException.connectionTimeout:
        return ServerFailure( 'connectionTimeout Error');
      case DioException.receiveTimeout:
        return ServerFailure( 'receiveTimeout Error');
      case DioException.sendTimeout:
        return ServerFailure( 'sendTimeout Error');
      case DioException.badResponse:
        return ServerFailure.formResponse(
            e.response!.statusCode!, e.response!.data!);
      case DioException.requestCancelled:
        return ServerFailure( 'requestCancelled Exception');
      default:
        return ServerFailure( 'defualt Error');
    }
  }
  factory ServerFailure.formResponse(int statusCode, dynamic response) {
    if (statusCode == 500) {
      return ServerFailure( 'there is problem with server');
    } else if (statusCode == 404) {
      return ServerFailure( 'your Request was not found');
    }else if (statusCode == 429) {
      return ServerFailure( 'Rate Limit Exceeded: Too Many Requests');
    } else if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(
           'Bad Requset $statusCode your response is:$response ');
    } else {
      return ServerFailure( 'unknown Error');
    }
  }
}
