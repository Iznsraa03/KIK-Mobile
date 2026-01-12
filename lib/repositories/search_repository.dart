import '../api/api_client.dart';
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
    return KiSearchItem(
      id: id,
      category: _parseCategory(json['category']),
      title: (json['title']?.toString().trim().isNotEmpty ?? false)
          ? json['title'].toString()
          : '(Tanpa judul)',
      description: json['description']?.toString() ?? '',
      region: json['region']?.toString() ?? '-',
      status: json['status']?.toString() ?? '-',
      image: json['image']?.toString(),
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
