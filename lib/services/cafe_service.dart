import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/cafe_model.dart';

class CafeService {
  late final Dio _dio;

  static const String _baseUrl = 'https://api.sampleapis.com'; //Url de la api
  static const String _coffeeEndpoint = '/coffee/hot'; //endpoint de la api

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
      // metodos adicionales que se ejecutan al hacer una petición o respuesta, para el manejo de errores y logs detallados, ver lo que está pasando..
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
      final response = await _dio.get(_coffeeEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data
                as List<dynamic>; //convertir la respuesta en un objeto dinámico
        return data
            .map((item) => CafeModel.fromJson(item as Map<String, dynamic>))
            .toList(); //convertir cada elemento en un objeto CafeModel
      } else {
        throw Exception(
          'El servidor respondió con código ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      throw Exception(dioError);
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al procesar los datos');
    }
  }
}
