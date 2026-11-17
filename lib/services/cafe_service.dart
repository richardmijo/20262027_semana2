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
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
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
        onResponse: (response, handler) {
          log('Dio response');
          return handler.next(response);
        },
        onError: (error, handler) {
          log('Dio error');
          return handler.next(error);
        },
      ),
    );
  }

  Future<List<CafeModel>> obtenerCafes() async {
    try {
      final response = await _dio.get(_coffeEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((item) => CafeModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'El servidor respondio con codigo ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      throw Exception(_interpretarDioError(dioError));
    } catch (e) {
      throw Exception('Ocurrio un error inesperado al procesar los datos');
    }
  } // <- aquí se cierra obtenerCafes()

  String _interpretarDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'El servidor tardo demasiado';
      case DioExceptionType.connectionError:
        return 'No hay conexion a internet';
      case DioExceptionType.badResponse:
        return 'Error en el servidor';
      case DioExceptionType.cancel:
        return 'La peticion fue cancelada';
      default:
        return 'Error en la red';
    }
  }
}