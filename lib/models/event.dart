class Event {
  final int id;
  final String gambar;
  final String judul;
  final String wilayah;
  final DateTime waktuPelaksanaan;
  final String deskripsi;
  final String linkPendaftaran;
  final List<String>? media;

  Event({
    required this.id,
    required this.gambar,
    required this.judul,
    required this.wilayah,
    required this.waktuPelaksanaan,
    required this.deskripsi,
    required this.linkPendaftaran,
    this.media,
  });

  factory Event.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw ArgumentError('Obyek JSON tidak valid');
    }

    List<String>? mediaList;
    if (json['media'] is List) {
      mediaList = List<String>.from(json['media']);
    }

    return Event(
      id: json['id'],
      gambar: json['gambar'],
      judul: json['judul'],
      wilayah: json['wilayah'],
      waktuPelaksanaan: DateTime.parse(json['waktu_pelaksanaan']),
      deskripsi: json['deskripsi'],
      linkPendaftaran: json['link_pendaftaran'],
      media: mediaList,
    );
  }
}
