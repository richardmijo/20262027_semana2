import 'dart:developer';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:semana2/models/cafe_model.dart';

class CafeService {
  late final Dio _dio;
  bool usandoRespaldo = false;

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
      ), //BaseOptions
    ); //Dio

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
    usandoRespaldo = false;
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
      final statusCode = dioError.response?.statusCode;
      if (statusCode != null && statusCode >= 500) {
        usandoRespaldo = true;
        final jsonLocal = await rootBundle.loadString('assets/data/cafes.json');
        final data = jsonDecode(jsonLocal) as List<dynamic>;
        log('Sample API no disponible; usando JSON local de respaldo');
        return data
            .map((item) => CafeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception(interpretarDioError(dioError));
    } catch (e) {
      throw Exception('Ocurrio un error inesperado al procesar los datos');
    }
  }

  String interpretarDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'El servidor tardo demasiado';

      case DioExceptionType.connectionError:
        return 'No hay conexion a internet';

      case DioException.badResponse:
        return 'Error en el servidor (${error.response?.statusCode ?? 'sin código'}).';

      case DioExceptionType.cancel:
        return 'La peticion fue cancelada';

      default:
        return 'Error en la red';
    }
  }
}
