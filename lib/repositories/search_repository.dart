import '../api/api_client.dart';
import '../api/api_config.dart';
import '../api/api_exception.dart';
import '../api/api_models.dart';
import '../data/dummy_data.dart';

/// Result item dari endpoint global `/search`.
class KiSearchItem {
  const KiSearchItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.region,
    required this.status,
    this.image,
    this.createdAt,
  });

  final String id;
  final KiCategoryType category;
  final String title;
  final String description;
  final String region;
  final String status;
  final String? image;
  final DateTime? createdAt;
}

class SearchRepository {
  SearchRepository({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;

  String? _absUrlIfNeeded(String? value) {
    if (value == null) return null;
    final v = value.trim();
    if (v.isEmpty || v == '-') return null;

    final base = ApiConfig.fileBaseUrl.replaceAll(RegExp(r'/+$'), '');

    // absolute URL -> biarkan
    if (v.startsWith('http://') || v.startsWith('https://')) return v;

    // Heuristik: jika hanya filename (contoh: "abc.jpg"), pada backend kamu
    // file ada di `public/storage/gambar/<filename>`.
    // Maka public URL-nya biasanya: `/storage/gambar/<filename>`.
    //
    // Catatan: ini mengasumsikan Laravel sudah expose folder `public/storage`.
    final looksLikeFileNameOnly = !v.contains('/') && v.contains('.');
    if (looksLikeFileNameOnly) {
      return '$base/storage/gambar/$v';
    }

    // relative path (storage/... , berita/... , media/... , dll)
    final rel = v.startsWith('/') ? v.substring(1) : v;
    return '$base/$rel';
  }

  KiCategoryType _parseCategory(Object? raw) {
    final v = raw?.toString().toUpperCase().trim();
    return switch (v) {
      'EBT' => KiCategoryType.ebt,
      'PT' => KiCategoryType.pt,
      'PIG' => KiCategoryType.pig,
      'SDG' => KiCategoryType.sdg,
      'IA' => KiCategoryType.ia,
      'IG' => KiCategoryType.ig,
      _ => KiCategoryType.ebt,
    };
  }

  KiSearchItem _parseItem(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw ApiException('Format item search tidak valid', details: json);
    }

    final id = json['id']?.toString() ?? '';

    // Support beberapa variasi key dari backend:
    // - /search (SearchController): `image` -> biasanya berisi `$item->gambar` atau `$item->logo`
    // - response detail model: `gambar` (kadang filename saja)
    // - kemungkinan lain: `imagepath`
    final rawImage = (json['imagepath'] ?? json['gambar'] ?? json['image'])?.toString();

    return KiSearchItem(
      id: id,
      category: _parseCategory(json['category']),
      title: (json['title']?.toString().trim().isNotEmpty ?? false)
          ? json['title'].toString()
          : '(Tanpa judul)',
      description: json['description']?.toString() ?? '',
      region: json['region']?.toString() ?? '-',
      status: json['status']?.toString() ?? '-',
      image: _absUrlIfNeeded(rawImage),
      createdAt: json['created_at'] is String
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  /// Global search.
  ///
  /// Laravel expects:
  /// - q (required)
  /// - category: ebt|pt|pig|sdg|ia|ig (optional)
  /// - region, status (optional)
  Future<ApiResponse<List<KiSearchItem>>> search({
    required String q,
    KiCategoryType? category,
    String? region,
    String? status,
    int page = 1,
    int perPage = 20,
  }) async {
    final query = q.trim();
    if (query.isEmpty) {
      return ApiResponse<List<KiSearchItem>>(success: true, data: const []);
    }

    String? categorySlug;
    if (category != null) {
      categorySlug = switch (category) {
        KiCategoryType.ebt => 'ebt',
        KiCategoryType.pt => 'pt',
        KiCategoryType.pig => 'pig',
        KiCategoryType.sdg => 'sdg',
        KiCategoryType.ia => 'ia',
        KiCategoryType.ig => 'ig',
      };
    }

    final json = await _api.getJson(
      '/search',
      queryParameters: {
        'q': query,
        'category': categorySlug,
        'region': region,
        'status': status,
        'page': '$page',
        'per_page': '$perPage',
      },
    );

    return ApiResponse.listFromJson<KiSearchItem>(json, _parseItem);
  }
}
