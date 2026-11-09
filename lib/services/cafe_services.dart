import 'dart:math';

import 'package:dio/dio.dart';
import 'package:semana2/models/cafe_model.dart';

class CafeServices {
  late final Dio _dio;
  
  static const String _baseUrl = 'https://api.sampleapis.com';
  static const String _cafesEndpoint = '/cofee/hot';

  CafeServices(){
      _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: Duration(seconds: 8),
          receiveTimeout: Duration(seconds: 8),
          headers: {
            "Acept": "application/json",
            "Content-Type": "application/json",
          }
        ),
      );
      _dio.interceptors.add(  
        InterceptorsWrapper(
          onRequest: (options, handler){
            log("Dio request" as num);
            return handler.next(options);
          },
          onResponse: (response, handler) {
            log("Dio response" as num);
            return handler.next(response);
          },
          onError:(option, handler) {
            log("Dio error" as num);
            return handler.next(option);
          },
        ),
      );
    } 
    Future<List<CafeModel>> obtenerCafes() async{
      try{
        final response = await _dio.get(_cafesEndpoint);
        if(responce.statusCode == 200){
          final List<dynamic> data = response.data;
          return data.map((item) =>
          CafeModel.fromJson(item as Map<String, dynamic>)).toList();

        } 
      } on Dioexception catch (e){
        throw Exception(dioError);
      } catch (e){
        throw Exception("Ocurrio un error inesperado al obtener los datos");
      }
    }

  }

