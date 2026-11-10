import 'package:dio/dio.dart';

import 'dart:developer';

import '../models/cafe_model.dart';

class CafeService {
  late final Dio _dio;

  static const String _baseUrl = 'https://api.sampeapis.com';
  static const String _coffeeEndpoint = '/coffee/hot';

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
        onError: (options, handler) {
          log('Dio error');
          return handler.next(options);
        },
      ),
    );
  }

  Future<List<CafeModel>> obtenerCafes() async {
    try {
      final response = await _dio.get(_coffeeEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;

        return data
            .map((item) => CafeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'El servidor respondió con código ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      log('Error de conexión: ${dioError.message}');
      throw Exception('Error al conectar con el servidor');
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al procesar los datos');
    }
  }
}
