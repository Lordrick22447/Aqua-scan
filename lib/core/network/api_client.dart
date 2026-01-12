import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client client;

  ApiClient({required this.baseUrl, http.Client? client})
    : client = client ?? http.Client();

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint'),
      body: jsonEncode(body),
      headers: headers ?? {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error: ${response.reasonPhrase}',
        body: response.body,
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic body;

  ApiException({required this.statusCode, required this.message, this.body});

  @override
  String toString() => 'ApiException: $statusCode - $message\nBody: $body';
}
