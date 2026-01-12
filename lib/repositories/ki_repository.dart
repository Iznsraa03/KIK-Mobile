import '../api/api_client.dart';
import '../api/api_config.dart';
import '../api/api_exception.dart';
import '../api/api_models.dart';
import '../data/dummy_data.dart';

/// Repository untuk konsumsi API KI berdasarkan dokumentasi.
///
/// Endpoint base: {baseUrl}/...
/// - /ebt
/// - /pt
/// - /pig
/// - /sdg
/// - /ia
/// - /indikasi-geografis
class KiRepository {
  KiRepository({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;

  String _pathOf(KiCategoryType type) {
    // NOTE: Sesuaikan dengan route Laravel yang ada di `php artisan route:list`.
    // Di project backend kamu, endpoint kategori berada di bawah prefix `api/ki/*`.
    return switch (type) {
      KiCategoryType.ebt => '/ki/ebt',
      KiCategoryType.pt => '/ki/pt',
      KiCategoryType.pig => '/ki/pig',
      KiCategoryType.sdg => '/ki/sdg',
      KiCategoryType.ia => '/ki/ia',
      // Indikasi Geografis di backend memakai slug `ig`.
      KiCategoryType.ig => '/ki/ig',
    };
  }

  /// Parse item dari JSON API dengan fallback beberapa nama field umum.
  /// Karena dokumentasi kamu belum mencantumkan schema field item, mapper dibuat defensif.
  /// Folder default untuk file gambar KI.
  ///
  /// Dari struktur backend kamu, file KI disimpan di:
  /// `public/storage/gambar/<filename>`
  String _kiImageFolder() => 'gambar';

  /// Normalisasi path gambar/logo yang kadang hanya berisi filename.
  ///
  /// Backend idealnya menyimpan path seperti `storage/<folder>/<filename>`.
  /// Namun untuk data lama, field bisa berisi filename saja.
  /// Kalau hanya filename, kita asumsi lokasinya ada di `public/storage/<folder>/`.
  String? _normalizeMediaPath(String? value, KiCategoryType type) {
    // (dipakai untuk gambar utama KI)

    if (value == null) return null;
    final v = value.trim();
    if (v.isEmpty || v == '-') return null;

    // absolute URL -> biarkan
    if (v.startsWith('http://') || v.startsWith('https://')) return v;

    // sudah punya path (contoh: storage/ebt/xxx.jpg, berita/xxx.jpg, media/xxx.jpg)
    if (v.contains('/')) return v;

    // filename only -> prefix ke folder default backend (`storage/gambar/<file>`)
    final folder = _kiImageFolder();
    return 'storage/$folder/$v';
  }

  /// Normalisasi item `media[]` dari detail KI.
  ///
  /// Di backend kamu, file media tambahan disimpan di:
  /// `public/media/<filename>`.
  /// Response API mengirimkan filename saja, jadi perlu diprefix `media/`.
  bool _looksLikeVideo(String value) {
    final lower = value.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.m4v') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.m3u8');
  }

  /// Normalisasi item `media[]` dari detail KI.
  ///
  /// Di backend kamu, file media tambahan disimpan di:
  /// `public/media/<filename>`.
  ///
  /// IMPORTANT: untuk video (terutama iOS), server harus mendukung HTTP Range.
  /// Banyak setup web server akan menyajikan file `public/media/*` sebagai static file
  /// tanpa Range support yang benar. Karena itu, untuk video kita arahkan ke endpoint
  /// Laravel `/media-stream/<filename>`.
  String? _normalizePublicMediaItem(String? value) {
    if (value == null) return null;
    final v = value.trim();
    if (v.isEmpty || v == '-') return null;

    // absolute URL -> biarkan
    if (v.startsWith('http://') || v.startsWith('https://')) return v;

    // sudah punya path. Jika ini video dan path-nya menunjuk /media/, ganti ke /media-stream/
    if (v.contains('/')) {
      if (_looksLikeVideo(v) && v.startsWith('media/')) {
        return v.replaceFirst('media/', 'media-stream/');
      }
      return v;
    }

    // filename only
    if (_looksLikeVideo(v)) {
      return 'media-stream/$v';
    }

    return 'media/$v';
  }

  String? _absUrlIfNeeded(String? value) {
    if (value == null) return null;
    final v = value.trim();
    if (v.isEmpty || v == '-') return null;

    final base = ApiConfig.fileBaseUrl.replaceAll(RegExp(r'/+$'), '');

    // Jika sudah absolute URL, normalisasi untuk kasus dev yang umum:
    // backend jalan di :8000 tetapi API mengirim `http://localhost/media/...` (tanpa port)
    // atau `127.0.0.1/media/...`. Kita pindahkan ke origin yang sama dengan fileBaseUrl.
    if (v.startsWith('http://') || v.startsWith('https://')) {
      try {
        final uri = Uri.parse(v);
        final baseUri = Uri.parse(base);

        final looksLikeLocalhost =
            uri.host == 'localhost' || uri.host == '127.0.0.1';
        final missingPortButBaseHasPort = uri.hasPort == false && baseUri.hasPort;

        final isSameHostButWrongPort =
            looksLikeLocalhost && missingPortButBaseHasPort;

        // Jika path sudah /media/<file>, cukup ganti scheme+authority.
        if (isSameHostButWrongPort) {
          return uri
              .replace(scheme: baseUri.scheme, host: baseUri.host, port: baseUri.port)
              .toString();
        }
      } catch (_) {
        // jika parse gagal, biarkan
      }
      return v;
    }

    // Jika server mengembalikan path relatif/filename, prefix dengan fileBaseUrl.
    final rel = v.startsWith('/') ? v.substring(1) : v;
    return '$base/$rel';
  }

  List<String> _splitLinks(String? multiline) {
    if (multiline == null) return const [];
    return multiline
        .split(RegExp(r'[\r\n]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }

  /// Parse `link_resource` dari backend.
  ///
  /// Variasi yang pernah ditemui:
  /// - String multi-line (dipisah newline)
  /// - `List<String>`
  /// - Map (mis: { url: "..." } atau { links: [...] })
  String _sanitizeUrl(String input) {
    // Beberapa data mengandung spasi/newline yang memecah URL, mis:
    // - "https:// www.example.com/..."
    // - "wisata-\nkuliner/..."
    // Untuk kasus ini, kita hapus whitespace di dalam string.
    final trimmed = input.trim();
    return trimmed.replaceAll(RegExp(r'\s+'), '');
  }

  List<String> _parseResourceLinks(Object? raw) {
    if (raw == null) return const [];

    // List -> ambil semua sebagai string
    if (raw is List) {
      return raw
          .map((e) => e?.toString())
          .whereType<String>()
          .map(_sanitizeUrl)
          .where((s) => s.isNotEmpty)
          .toList(growable: false);
    }

    // Map -> dukung beberapa bentuk:
    // 1) { links: [...] } atau { link_resource: ... }
    // 2) { 0: 'https://...', 2: 'https://...' } (key numerik)
    if (raw is Map) {
      final candidates = [raw['links'], raw['link_resource'], raw['url'], raw['href']];
      for (final c in candidates) {
        final parsed = _parseResourceLinks(c);
        if (parsed.isNotEmpty) return parsed;
      }

      // Jika Map berisi key numerik -> kumpulkan value sebagai list (urut key).
      final numericEntries = <({int? index, String value})>[];
      for (final e in raw.entries) {
        final key = e.key;
        final val = e.value;
        if (val == null) continue;

        final idx = key is int
            ? key
            : (key is String ? int.tryParse(key.trim()) : null);

        // hanya ambil value yang kelihatan seperti URL/string
        if (val is String) {
          numericEntries.add((index: idx, value: val));
        } else if (val is List || val is Map) {
          // dukung nested
          for (final v in _parseResourceLinks(val)) {
            numericEntries.add((index: idx, value: v));
          }
        }
      }

      if (numericEntries.isNotEmpty) {
        numericEntries.sort((a, b) {
          final ai = a.index ?? 1 << 30;
          final bi = b.index ?? 1 << 30;
          return ai.compareTo(bi);
        });

        return numericEntries
            .map((e) => _sanitizeUrl(e.value))
            .where((s) => s.isNotEmpty)
            .toList(growable: false);
      }

      // fallback: jadikan string (untuk debug / data tak terduga)
      final s = raw.toString().trim();
      return s.isEmpty ? const [] : [_sanitizeUrl(s)];
    }

    // String -> split line
    if (raw is String) {
      return _splitLinks(raw).map(_sanitizeUrl).toList(growable: false);
    }

    // Tipe lain -> stringkan
    final s = raw.toString().trim();
    return s.isEmpty ? const [] : [_sanitizeUrl(s)];
  }

  DateTime? _parseDate(Object? v) {
    if (v is String && v.trim().isNotEmpty) {
      return DateTime.tryParse(v.trim());
    }
    return null;
  }

  KiItem _parseKiItem(Object? json, KiCategoryType type) {
    if (json is! Map<String, dynamic>) {
      throw ApiException('Format item tidak valid', details: json);
    }

    String stringAny(List<String> keys, {String fallback = ''}) {
      for (final k in keys) {
        final v = json[k];
        if (v == null) continue;
        if (v is String && v.trim().isNotEmpty) return v;
        if (v is num) return '$v';
      }
      return fallback;
    }

    int intAny(List<String> keys, {int fallback = 0}) {
      for (final k in keys) {
        final v = json[k];
        if (v is int) return v;
        if (v is String) {
          final parsed = int.tryParse(v);
          if (parsed != null) return parsed;
        }
      }
      return fallback;
    }

    List<String> tagsAny(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v is List) {
          return v
              .map((e) => e?.toString().trim())
              .whereType<String>()
              .where((s) => s.isNotEmpty)
              .toList(growable: false);
        }
        if (v is String && v.trim().isNotEmpty) {
          // tags bisa berupa comma separated
          return v
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(growable: false);
        }
      }
      return const [];
    }

    final id = stringAny(['id', 'uuid', 'kode', 'nomor']);
    final title =
        stringAny(['judul', 'title', 'nama'], fallback: '(Tanpa judul)');

    // EBT: API memiliki `komunitas_asal` dan `nama_ki_komunal`.
    // Kita utamakan komunitas_asal untuk owner.
    final owner = stringAny(
      ['komunitas_asal', 'pemilik', 'owner', 'pengusul', 'pencipta'],
      fallback: '-',
    );

    final location = stringAny(
      ['daerah_asal', 'wilayah', 'kabupaten', 'kota', 'lokasi'],
      fallback: '-',
    );

    final status = stringAny(['status'], fallback: '-');

    // Ringkasan singkat
    final summary = stringAny(
      ['deskripsi', 'ringkasan', 'summary', 'keterangan'],
      fallback: '-',
    );

    // Konten lengkap (untuk detail)
    final content = stringAny(['isi'], fallback: '');

    // Tahun: EBT tidak punya field tahun; fallback ke year/created_at
    var year = intAny(['tahun', 'year'], fallback: 0);

    final createdAt = _parseDate(json['created_at']);
    final updatedAt = _parseDate(json['updated_at']);
    if (year == 0 && createdAt != null) year = createdAt.year;

    // Media
    // Prioritas gambar utama:
    // 1) media_url (sudah absolute URL dari API)
    // 2) gambar/logo (path relatif atau filename)
    final rawPrimaryImage = stringAny(['media_url', 'gambar', 'logo'], fallback: '');
    final imagePath = _absUrlIfNeeded(
      _normalizeMediaPath(rawPrimaryImage, type),
    );

    // Media list:
    // 1) media_urls (absolute URLs)
    // 2) media (filename list)
    List<String>? media;
    final rawMediaUrls = json['media_urls'];
    if (rawMediaUrls is List) {
      final list = rawMediaUrls
          .map((e) => _absUrlIfNeeded(e?.toString()))
          .whereType<String>()
          .toList(growable: false);

      // Dedup (jaga-jaga jika media_url juga termasuk di media_urls)
      media = {
        ...list,
      }.toList(growable: false);
    } else {
      final rawMedia = json['media'];
      if (rawMedia is List) {
        media = rawMedia
            .map((e) => _absUrlIfNeeded(_normalizePublicMediaItem(e?.toString())))
            .whereType<String>()
            .toList(growable: false);
      }
    }

    // Link resource bisa berupa string multi-line (EBT lama) atau list string (contoh PT).
    // Di beberapa endpoint, backend bisa mengirim object (Map) alih-alih String.
    List<String> resourceLinks = const [];
    final rawLinks = json['link_resource'];
    resourceLinks = _parseResourceLinks(rawLinks);

    final tags = tagsAny(['tag', 'tags', 'kata_kunci']);

    return KiItem(
      id: id,
      category: type,
      title: title,
      owner: owner,
      location: location,
      year: year,
      status: status,
      summary: summary,
      tags: tags,
      content: content.isEmpty ? null : content,
      imagePath: imagePath,
      media: media,
      resourceLinks: resourceLinks.isEmpty ? null : resourceLinks,
      community: stringAny(['komunitas_asal'], fallback: ''),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Future<ApiResponse<List<KiItem>>> getCategoryItems(
    KiCategoryType type, {
    String? search,
    String? daerahAsal,
    String? status,
    int page = 1,
    int perPage = 15,
  }) async {
    final json = await _api.getJson(
      _pathOf(type),
      queryParameters: {
        'search': search,
        'region': daerahAsal,
        'status': status,
        'page': '$page',
        'per_page': '$perPage',
      },
    );

    return ApiResponse.listFromJson<KiItem>(
      json,
      (itemJson) => _parseKiItem(itemJson, type),
    );
  }

  /// Ambil total count data per kategori.
  ///
  /// Laravel sudah menyediakan endpoint statistik per kategori:
  /// GET `/ki/<type>/statistics` -> { status: 'success', data: { total: ..., ... } }
  Future<int> getCategoryTotalCount(KiCategoryType type) async {
    final json = await _api.getJson('${_pathOf(type)}/statistics');
    if (json['status'] != 'success') {
      throw ApiException('Gagal mengambil statistik kategori', details: json);
    }

    final data = json['data'];
    if (data is! Map) {
      throw ApiException('Format statistik kategori tidak valid', details: json);
    }

    final total = data['total'];
    if (total is int) return total;
    if (total is String) return int.tryParse(total) ?? 0;
    if (total is num) return total.toInt();
    return 0;
  }

  Future<KiItem> getDetail(KiCategoryType type, String id) async {
    final json = await _api.getJson('${_pathOf(type)}/$id');
    final res = ApiResponse.objectFromJson<KiItem>(
      json,
      (dataJson) => _parseKiItem(dataJson, type),
    );

    if (!res.success) {
      throw ApiException('Request detail gagal', details: json);
    }

    return res.data;
  }

}
