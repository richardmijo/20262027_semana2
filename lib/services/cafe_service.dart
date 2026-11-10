import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/cafe_model.dart';
class CafeService {
  late final Dio _dio;
  static const _baseUrl = 'https://api.sampleapis.com';
  static const _coffeEndpoint = '/coffee/hot';

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

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        log('Dio request');
        handler.next(options);
      },
      onResponse: (response, handler) {
        log('Dio response');
        handler.next(response);
      },
      onError: (error, handler) {
        log('Dio error');
        handler.next(error);
      },
    ));
  }

  Future<List<CafeModel>> obtenerCafes() async {
    try {
      final response = await _dio.get(_coffeEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;

        return data
            .map((item) => CafeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener los cafés');
      }
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al procesar los datos');
    }
  }
}