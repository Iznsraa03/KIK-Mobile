/// Central place to configure API base URL.
///
/// Default based on your documentation:
///   http://127.0.0.1:8000/api
///
/// Notes:
/// - Android emulator cannot reach your host machine via 127.0.0.1.
///   Use http://10.0.2.2:8000/api instead.
/// - iOS simulator can use 127.0.0.1 if backend runs on the same Mac.
class ApiConfig {
  /// Base URL API (Laravel) untuk JSON.
  ///
  /// Contoh:
  /// - Dev (Mac + iOS simulator / Chrome): `http://localhost:8000/api`
  /// - Android emulator: `http://10.0.2.2:8000/api`
  /// - Device fisik: `http://<ip-laptop>:8000/api`
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api',
  );

  /// Base URL untuk file publik (gambar/media).
  ///
  /// Laravel kamu bisa mengembalikan path relatif seperti:
  /// - `storage/pt/<file>` (dari BaseKiController)
  /// - `berita/<file>` (dari BeritaController)
  /// - atau path custom lain.
  ///
  /// Karena itu, base URL file yang aman adalah origin server (tanpa `/api`).
  ///
  /// Jika `FILE_BASE_URL` tidak di-set, kita turunkan otomatis dari `API_BASE_URL`
  /// (origin yang sama) agar tidak mismatch host/port.
  ///
  /// Override jika perlu:
  /// `--dart-define=FILE_BASE_URL=http://localhost:8000/media`
  static String get fileBaseUrl {
    const override = String.fromEnvironment('FILE_BASE_URL');
    if (override.trim().isNotEmpty) {
      return override.replaceAll(RegExp(r'/+$'), '');
    }

    final api = Uri.parse(baseUrl);
    final origin = '${api.scheme}://${api.authority}';
    return origin;
  }
}

