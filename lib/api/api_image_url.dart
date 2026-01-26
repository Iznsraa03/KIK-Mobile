class ApiImageUrl {
  static const String baseUrl = 'http://192.168.1.9:8000';

  static String build(String path) {
    if (path.startsWith('http')) {
      return path;
    }
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$baseUrl/storage/$cleanPath';
  }
}
