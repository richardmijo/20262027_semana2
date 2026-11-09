import 'package:dio/dio.dart';
import 'dart:developer';

import 'package:semana2/models/cafe_model.dart';

class CafeService {
  late final Dio _dio;

  static const String _baseUrl = 'https://api.example.com/cafes';
  static const String _coffeeEndpoint = '/coffe/hot';

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
        onError: (DioException e, handler) {
          log('Dio error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<List<CafeModel>> obtenerCafes() async {
    try {
      // Usamos 'response' de manera consistente
      final response = await _dio.get(_coffeeEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        // Corregido: .toList() iba dentro del .map() por error
        return data.map((item) => CafeModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        // Corregido: 'StatusCode' a 'statusCode' en minúscula
        throw Exception(
          'El servidor respondió con código ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      throw Exception(dioError.message);
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al procesar los datos: $e');
    }
  }
}