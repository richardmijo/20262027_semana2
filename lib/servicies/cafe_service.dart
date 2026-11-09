import 'dart:developer';
import 'package:dio/dio.dart';

import '../models/cafe_model.dart';

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
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((item) => CafeModel.fromJson(item )).toList();
      } else {
        throw Exception(
          'el servidor respondio con codigo: ${response.statusCode}',
      );
      }  

    } on DioException catch (dioError) {
      throw Exception(dioError);
    } catch (error) {
      throw Exception('Ocurrio un eririr ');;
    }
  }
}