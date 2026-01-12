/// Minimal models for the common Laravel Resource-like response shape.
///
/// Response umum:
/// `{ success: true, data: ..., meta: ..., links: ... }`
class ApiResponse<T> {
  ApiResponse({
    required this.success,
    required this.data,
    this.meta,
    this.links,
  });

  final bool success;
  final T data;
  final PaginationMeta? meta;
  final PaginationLinks? links;

  static ApiResponse<List<T>> listFromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? itemJson) itemParser,
  ) {
    final raw = json['data'];
    final list = (raw is List ? raw : const <dynamic>[])
        .map((e) => itemParser(e))
        .toList(growable: false);

    // Dukungan beberapa varian envelope backend:
    // - { success: true/false, data: ... }
    // - { status: "success"|"error", data: ... }
    // - atau tidak ada field status (anggap sukses jika HTTP 2xx)
    final success = json.containsKey('success')
        ? json['success'] == true
        : (json['status'] == 'success' || json['status'] == null);

    // Dukungan untuk 2 bentuk pagination:
    // 1) Resource pagination: { data: [], meta: {...}, links: {...} }
    // 2) Paginator standar: { current_page, last_page, per_page, total, data, ... }
    final meta = PaginationMeta.fromJson(json['meta']) ??
        PaginationMeta.fromJson(json['pagination']) ??
        PaginationMeta.fromJson({
          'current_page': json['current_page'],
          'last_page': json['last_page'],
          'per_page': json['per_page'],
          'total': json['total'],
        });

    final links = PaginationLinks.fromJson(json['links']) ??
        PaginationLinks.fromJson(json['pagination']) ??
        PaginationLinks.fromJson({
          'first': json['first_page_url'],
          'last': json['last_page_url'],
          'prev': json['prev_page_url'],
          'next': json['next_page_url'],
        });

    return ApiResponse<List<T>>(
      success: success,
      data: list,
      meta: meta,
      links: links,
    );
  }

  static ApiResponse<T> objectFromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? dataJson) parser,
  ) {
    final success = json.containsKey('success')
        ? json['success'] == true
        : (json['status'] == 'success' || json['status'] == null);

    return ApiResponse<T>(
      success: success,
      data: parser(json['data']),
      meta: PaginationMeta.fromJson(json['meta']),
      links: PaginationLinks.fromJson(json['links']),
    );
  }
}

class PaginationLinks {
  const PaginationLinks({this.first, this.last, this.prev, this.next});

  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  static PaginationLinks? fromJson(Object? json) {
    if (json is! Map<String, dynamic>) return null;

    String? toStr(Object? v) {
      if (v == null) return null;
      if (v is String) return v;
      // Beberapa backend mengirim { url: "..." } atau struktur lain.
      if (v is Map) {
        final url = v['url'] ?? v['href'] ?? v['link'];
        return url?.toString();
      }
      return v.toString();
    }

    return PaginationLinks(
      first: toStr(json['first']),
      last: toStr(json['last']),
      prev: toStr(json['prev']),
      next: toStr(json['next']),
    );
  }
}

class PaginationMeta {
  const PaginationMeta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  static PaginationMeta? fromJson(Object? json) {
    if (json is! Map<String, dynamic>) return null;

    int? toInt(Object? v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      return null;
    }

    return PaginationMeta(
      currentPage: toInt(json['current_page']),
      lastPage: toInt(json['last_page']),
      perPage: toInt(json['per_page']),
      total: toInt(json['total']),
    );
  }
}
