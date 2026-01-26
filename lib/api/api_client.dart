import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';
import 'api_logger.dart';
import 'api_models.dart';
import '../models/event.dart';

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? ApiConfig.baseUrl).replaceAll(RegExp(r'/+$'), '');

  final http.Client _client;
  final String _baseUrl;

  Future<ApiResponse<List<Event>>> getEvents() async {
    final json = await getJson('/events');
    return ApiResponse.listFromJson(json, Event.fromJson);
  }

  Uri _uri(String path, [Map<String, String?>? queryParameters]) {
    final cleanedPath = path.startsWith('/') ? path : '/$path';
    final qp = <String, String>{};
    queryParameters?.forEach((k, v) {
      if (v == null) return;
      final trimmed = v.trim();
      if (trimmed.isEmpty) return;
      qp[k] = trimmed;
    });

    return Uri.parse('$_baseUrl$cleanedPath').replace(queryParameters: qp);
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String?>? queryParameters,
  }) async {
    final uri = _uri(path, queryParameters);
    final startedAt = DateTime.now();

    ApiLogger.instance.log('GET $uri');

    http.Response res;
    try {
      res = await _client.get(uri, headers: {
        'Accept': 'application/json',
      });
    } catch (e) {
      ApiLogger.instance.log('GET $uri -> network error: $e');
      throw ApiException('Gagal menghubungi server API', details: e);
    }

    final status = res.statusCode;
    final body = res.body;
    final elapsedMs = DateTime.now().difference(startedAt).inMilliseconds;

    ApiLogger.instance.log('GET $uri -> $status (${elapsedMs}ms)');

    if (status < 200 || status >= 300) {
      // Avoid dumping huge HTML error pages; still show some prefix.
      final preview = body.length > 800 ? '${body.substring(0, 800)}…' : body;
      ApiLogger.instance.log('GET $uri -> HTTP error body preview: $preview');

      throw ApiException(
        'HTTP error $status',
        statusCode: status,
        details: body,
      );
    }

    try {
      // Beberapa environment PHP/Laravel (terutama saat APP_DEBUG=true)
      // bisa menyisipkan HTML warning/notice sebelum JSON (contoh: "<br><b>Deprecated</b>...").
      // Ini membuat jsonDecode gagal di Flutter (terutama Flutter Web).
      //
      // Karena kamu tidak ingin mengubah backend, kita cari payload JSON pertama
      // lalu parse dari sana.
      String normalizedBody = body;

      // Cari token JSON pertama: object `{` atau array `[`.
      final firstObj = body.indexOf('{');
      final firstArr = body.indexOf('[');
      int firstJson;
      if (firstObj == -1) {
        firstJson = firstArr;
      } else if (firstArr == -1) {
        firstJson = firstObj;
      } else {
        firstJson = firstObj < firstArr ? firstObj : firstArr;
      }

      if (firstJson > 0) {
        final prefix = body.substring(0, firstJson);
        // Jika ada indikasi HTML (warning/notice), buang prefixnya.
        if (prefix.contains('<') || prefix.toLowerCase().contains('deprecated')) {
          normalizedBody = body.substring(firstJson);
        }
      }

      final decoded = jsonDecode(normalizedBody);
      if (decoded is Map<String, dynamic>) return decoded;
      ApiLogger.instance.log(
        'GET $uri -> JSON invalid (expected object), got: ${decoded.runtimeType}',
      );
      throw ApiException(
        'Response JSON tidak valid: bukan object',
        details: decoded,
      );
    } catch (e) {
      final preview = body.length > 800 ? '${body.substring(0, 800)}…' : body;
      ApiLogger.instance
          .log('GET $uri -> JSON parse error: $e | body preview: $preview');
      throw ApiException('Gagal parsing JSON', statusCode: status, details: e);
    }
  }
}
