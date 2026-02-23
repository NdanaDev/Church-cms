import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  static String? _token() =>
      Supabase.instance.client.auth.currentSession?.accessToken;

  static Map<String, String> _headers({bool json = true}) {
    final token = _token();
    return {
      if (json) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      String msg;
      try {
        final body = jsonDecode(res.body);
        msg = body['message'] ?? body['error'] ?? res.body;
      } catch (_) {
        msg = res.body;
      }
      throw ApiException(res.statusCode, msg);
    }
  }

  static Future<dynamic> get(String path) async {
    final res = await http.get(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers(json: false),
    );
    _check(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    _check(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    _check(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  static Future<void> delete(String path) async {
    final res = await http.delete(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers(json: false),
    );
    _check(res);
  }
}
