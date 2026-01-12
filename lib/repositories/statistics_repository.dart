import '../api/api_client.dart';
import '../api/api_exception.dart';

/// Repository untuk endpoint statistik Laravel.
///
/// Routes (lihat `Projeck-KIK/routes/api.php`):
/// - GET /statistics
/// - GET /region-statistics
/// - GET /status-distribution
class StatisticsRepository {
  StatisticsRepository({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;

  /// Response:
  /// { status: 'success', data: { ebt: 1, pt: 2, ..., total: 10 } }
  Future<Map<String, int>> getOverallCounts() async {
    final json = await _api.getJson('/statistics');
    if (json['status'] != 'success') {
      throw ApiException('Gagal mengambil statistik', details: json);
    }

    final data = json['data'];
    if (data is! Map) {
      throw ApiException('Format statistik tidak valid', details: json);
    }

    final map = <String, int>{};
    data.forEach((k, v) {
      final key = k?.toString();
      if (key == null) return;
      if (v is int) {
        map[key] = v;
      } else if (v is String) {
        map[key] = int.tryParse(v) ?? 0;
      } else if (v is num) {
        map[key] = v.toInt();
      }
    });

    return map;
  }

  /// Response:
  /// { status: 'success', data: [ { region: 'Kab. Gowa', ebt: 1, ..., total: 6 }, ... ] }
  Future<List<Map<String, dynamic>>> getRegionStatistics() async {
    final json = await _api.getJson('/region-statistics');
    if (json['status'] != 'success') {
      throw ApiException('Gagal mengambil statistik wilayah', details: json);
    }

    final data = json['data'];
    if (data is! List) {
      throw ApiException('Format statistik wilayah tidak valid', details: json);
    }

    return data.whereType<Map<String, dynamic>>().toList(growable: false);
  }

  /// Response:
  /// { status: 'success', data: { ebt: {"Terverifikasi": 10, ...}, ... } }
  Future<Map<String, Map<String, int>>> getStatusDistribution() async {
    final json = await _api.getJson('/status-distribution');
    if (json['status'] != 'success') {
      throw ApiException('Gagal mengambil distribusi status', details: json);
    }

    final data = json['data'];
    if (data is! Map) {
      throw ApiException('Format distribusi status tidak valid', details: json);
    }

    final out = <String, Map<String, int>>{};
    data.forEach((k, v) {
      final key = k?.toString();
      if (key == null) return;
      if (v is Map) {
        final inner = <String, int>{};
        v.forEach((ik, iv) {
          final innerKey = ik?.toString();
          if (innerKey == null) return;
          if (iv is int) {
            inner[innerKey] = iv;
          } else if (iv is String) {
            inner[innerKey] = int.tryParse(iv) ?? 0;
          } else if (iv is num) {
            inner[innerKey] = iv.toInt();
          }
        });
        out[key] = inner;
      }
    });

    return out;
  }
}
