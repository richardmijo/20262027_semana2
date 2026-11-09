import 'dart:developer';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:semana2/models/cafe_model.dart';

class CafeService{
  late final Dio _dio;


  static const String _baseUrl = 'https://api.sampleapis.com';
  static const String _coffeEndpoint = '/coffee/hot';

  CafeService(){
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
        onRequest: (options, handler){
          log('Dio request');
          return handler.next(options);

        },
        onResponse: (options, handler) {
          log('Dio response');
          return handler.next(options);

        },

        onError: (options, hanlder) {
          log('Dio error');
          return hanlder.next(options);
        },

      ),
    );

  }

  Future<List<CafeModel>> obtenerCafes() async{
    try{
      final reponse = await _dio.get(_coffeEndpoint);
      if(reponse.statusCode == 200){
        final List<dynamic> data = reponse.data as List<dynamic>;
        return data.map((item) => CafeModel.fromJson(item as Map<String, dynamic>)) .toList();


      }else{
        throw Exception('El servidor respondio con codigo ${reponse.statusCode}'
        );

      }


    } on DioException catch(dioError){
      throw Exception(dioError);
    }catch(e){
      throw Exception('Ocurrio un error inesperado al procesar los datos');
    }
  }

}