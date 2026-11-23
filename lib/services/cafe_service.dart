import 'dart:developer';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:semana2/models/cafe_model.dart';

class CafeService {
  late final Dio _dio;

  static const String _baseUrl = 'https://raw.githubusercontent.com';
  static const String _coffeEndpoint =
      '/richardmijo/20262027_semana2/main/cafes.json';

  CafeService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: Duration(seconds: 8),
        receiveTimeout: Duration(seconds: 8),
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
      final response = await _dio.get(_coffeEndpoint);
      if (response.statusCode == 200) {
        final dynamic raw = response.data;
        final List<dynamic> data = raw is String
            ? jsonDecode(raw) as List<dynamic>
            : raw as List<dynamic>;
        return data.map((item) => CafeModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'El servidor respondió con código ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      throw Exception(_interpreterDioError(dioError));
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al procesar los datos');
    }
  }

  String _interpreterDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'El servidor tardó demasiado';

      case DioExceptionType.connectionError:
        return 'No hay conexión de internet'; // <-- Faltaba el punto y coma

      case DioExceptionType
          .badResponse: // <-- Corregido "dabResponse" por "badResponse"
        return "Error en el servidor";

      case DioExceptionType.cancel:
        return "La petición fue cancelada";

      default:
        return "Ocurrió un error en la red"; // <-- Corregido "ed" por "red"
    }
  }
}
