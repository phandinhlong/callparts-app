import 'dart:convert';
import 'package:http/http.dart' as http;

var urlMain= "http://10.0.2.2";
var urlAPI= "$urlMain/api/";


Map<String, String> getApiHeaders(String? token) {
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}


Map<String, String> defaultHeaders() =>
    {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

Future<http.Response> postRequest({
  required String url,
  required String endpoint,
  required Map<String, dynamic> requestData,
  Map<String, String>? headers,
  Duration timeout = const Duration(seconds: 30),
}) async {
  print(url+endpoint);
  final response = await http
      .post(
    Uri.parse('$url$endpoint'),
    headers: headers ?? {'Content-Type': 'application/json'},
    body: jsonEncode(requestData),
  )
      .timeout(timeout);

  return response;
}

Future<http.Response> getRequest({
  required String url,
  required String endpoint,
  Map<String, String>? headers,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final response = await http
      .get(
    Uri.parse('$url$endpoint'),
    headers: headers ?? defaultHeaders(),
  )
      .timeout(timeout);

  return response;
}
Future<http.Response> putRequest({
  required String url,
  required String endpoint,
  required Map<String, dynamic> requestData,
  Map<String, String>? headers,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final response = await http
      .put(
    Uri.parse('$url$endpoint'),
    headers: headers ?? {'Content-Type': 'application/json'},
    body: jsonEncode(requestData),
  )
      .timeout(timeout);

  return response;
}
Future<http.Response> deleteRequest({
  required String url,
  required String endpoint,
  Map<String, String>? headers,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final response = await http
      .delete(
    Uri.parse('$url$endpoint'),
    headers: headers ?? {'Content-Type': 'application/json'},
  )
      .timeout(timeout);

  return response;
}