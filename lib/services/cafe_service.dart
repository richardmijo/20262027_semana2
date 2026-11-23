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
          log('🌐 [DIO Request] ${options.method} -> ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('✅ [DIO Response ${response.statusCode}] desde ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          log('❌ [DIO Error] ${error.type} | ${error.message}');
          return handler.next(error);
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
        return 'El servidor tardó demasiado';

      case DioExceptionType.connectionError:
        return 'No hay conexión a internet';

      case DioExceptionType.badResponse:
        return 'Error en el servidor';

      case DioExceptionType.cancel:
        return 'La petición fue cacelada';

      default:
        return 'Error en la red';
    }
  }
}
