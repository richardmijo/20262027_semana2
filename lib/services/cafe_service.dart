import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:semana2/models/cafe_model.dart';

class CafeService {
  late final Dio _dio;

  // Endpoint 100% estable, sin caídas y con CORS habilitado (GitHub Raw)
  static const String _baseUrl = 'https://raw.githubusercontent.com';
  static const String _coffeEndpoint =
      '/richardmijo/20262027_semana2/main/cafes.json';

  CafeService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
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
      final response = await _dio.get(_coffeEndpoint);
      if (response.statusCode == 200) {
        // Maneja tanto List directo como String serializado en texto plano
        final dynamic raw = response.data;
        final List<dynamic> data = raw is String
            ? jsonDecode(raw) as List<dynamic>
            : raw as List<dynamic>;

        return data
            .map((item) => CafeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'El servidor respondió con código ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      throw Exception(_interpretarDioError(dioError));
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al procesar los datos: $e');
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
        return 'Error en el servidor: ${error.response?.statusCode ?? ''}';

      case DioExceptionType.cancel:
        return 'La petición fue cancelada';

      default:
        return 'Error en la red';
    }
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
      return 'La petición fue cancelada';

    default:
      return 'Error en la red';
  }
}