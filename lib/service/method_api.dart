import 'dart:convert';
import 'package:dio/dio.dart';

// var urlMain = "http://192.168.1.29:8000";
var urlMain = "https://callparts.vn";
var urlAPI = "$urlMain/api/";
var urlApp = "${urlAPI}call-parts/";
var urlImg= "https://callparts.vn";

Options getApiHeaders(String? token) {
  final headers = {
    'Accept': 'application/json',
  };

  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  return Options(headers: headers);
}

Options defaultHeaders() => Options(headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

final Dio _dio = Dio();

Future<Response> postRequest({
  required String url,
  required String endpoint,
  required Map<String, dynamic> requestData,
  Options? options,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final response = await _dio.post(
    '$url$endpoint',
    data: jsonEncode(requestData),
    options: options ?? Options(headers: {'Accept': 'application/json'}),
  ).timeout(timeout);
  return response;
}

Future<Response> getRequest({
  required String url,
  required String endpoint,
  Options? options,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final response = await _dio.get(
    '$url$endpoint',
    options: options ?? defaultHeaders(),
  ).timeout(timeout);

  return response;
}

Future<Response> putRequest({
  required String url,
  required String endpoint,
  required Map<String, dynamic> requestData,
  Options? options,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final response = await _dio.put(
    '$url$endpoint',
    data: jsonEncode(requestData),
    options: options ?? Options(headers: {'Content-Type': 'application/json'}),
  ).timeout(timeout);

  return response;
}

Future<Response> deleteRequest({
  required String url,
  required String endpoint,
  Options? options,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final response = await _dio.delete(
    '$url$endpoint',
    options: options ?? Options(headers: {'Content-Type': 'application/json'}),
  ).timeout(timeout);
  return response;
}