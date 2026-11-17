import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:semana2/models/cafe_model.dart';

class CafeService {
  late final Dio _dio;

  static const String _baseUrl = 'https://api.sampleapis.com';
  static const String _coffeEndpoint = '/coffee/hot';

  CafeService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: Duration(seconds: 8),
        receiveTimeout: Duration(seconds: 8),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('Dio request');
          return handler.next(options);
        },
        onResponse: (options, handler) {
          log('Dio response');
          return handler.next(options);
        },
        onError: (options, handler) {
          log('Dio error');
          return handler.next(options);
        },
      ),
    );
  }

  Future<List<CafeModel>> obtenerCafes() async {
    try {
      final reponse = await _dio.get(_coffeEndpoint);
      if (reponse.statusCode == 200) {
        final List<dynamic> data = reponse.data as List<dynamic>;
        return data.map((item) => CafeModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'El servidor respondio con codifo ${reponse.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      throw Exception(_interpretarDioError(dioError));
    } catch (e) {
      throw Exception('Ocurrio un erros inesperado al procesar los datos');
    }
  }

  String _interpretarDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'El servidor tardo demaciado';

      case DioExceptionType.connectionError:
        return 'No hay conexión con el servidor';

      case DioExceptionType.badResponse:
        return 'Error en el servidor';

      case DioExceptionType.cancel:
        return 'La peticion fue cancelada';

      default:
        return 'Error en la red';
    }
  }
}
