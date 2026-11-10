import 'dart:ffi';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:semana2/models/cafe_model.dart';

class CafeService {
  late final Dio _dio;
  static const _baseUrl = 'https://api.samplesapis.com';
  static const _coffeEndpoint = '/coffe/hot';

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
          log('Dio request' as num);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('Dio response' as num);
          return handler.next(response);
        },
        onError: (error, handler) {
          log('Dio error' as num);
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
        return data
            .map((item) => CafeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener los cafes');
      }
    } on DioException catch (dioError) {
      throw Exception(dioError);
    } catch (e) {
      throw Exception('Ocurrrio un error inesperado en el proceso');
    }
  }
}
