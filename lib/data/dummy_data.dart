import 'package:flutter/material.dart';

/// Jenis kategori KI yang ditampilkan di aplikasi.
///
/// Catatan: ini hanya untuk UI mockup (tanpa backend/database).
enum KiCategoryType {
  ebt,
  pt,
  pig,
  sdg,
  ia,
  ig,
}

/// Model kategori untuk kebutuhan tampilan grid di Beranda.
class KiCategory {
  const KiCategory({
    required this.type,
    required this.title,
    required this.subtitle,
    this.description,
    this.goals,
    required this.icon,
    required this.accent,
    required this.totalCount,
  });

  final KiCategoryType type;
  final String title;
  final String subtitle;
  final String? description;
  final String? goals;
  final IconData icon;
  final Color accent;
  final int totalCount;
}

/// Model item KI untuk kebutuhan list & detail.
class KiItem {
  const KiItem({
    required this.id,
    this.noPencatatan,
    required this.category,
    required this.title,
    required this.owner,
    required this.location,
    required this.year,
    required this.status,
    required this.summary,
    required this.tags,
    this.content,
    this.imagePath,
    this.media,
    this.resourceLinks,
    this.community,
    this.createdAt,
    this.updatedAt,
  });

  /// ID dari backend.
  ///
  /// Pada dummy data sebelumnya formatnya seperti `EBT-0001`.
  /// Dari API kamu berupa integer (contoh: `2`) yang kita simpan sebagai string.
  final String id;

  /// Nomor pencatatan/permohonan dari backend (API: `no_pencatatan`).
  final String? noPencatatan;

  final KiCategoryType category;

  /// Judul utama (API: `judul`).
  final String title;

  /// Pemilik/pencipta/pengusul.
  ///
  /// Untuk EBT API kamu, yang paling mendekati adalah `komunitas_asal`.
  final String owner;

  /// Wilayah / daerah asal (API: `daerah_asal`).
  final String location;

  /// Tahun (jika tersedia). Kalau tidak ada, akan 0.
  final int year;

  /// Status (API: `status`).
  final String status;

  /// Ringkasan singkat (API: `deskripsi`).
  final String summary;

  /// Tag/kata kunci.
  final List<String> tags;

  /// Konten lengkap (API: `isi`).
  final String? content;

  /// Nama file gambar utama (API: `gambar`) atau URL penuh.
  final String? imagePath;

  /// List media (API: `media`).
  final List<String>? media;

  /// Link sumber (API: `link_resource`). Bisa multi-line.
  final List<String>? resourceLinks;

  /// Komunitas asal (API: `komunitas_asal`).
  final String? community;

  final DateTime? createdAt;
  final DateTime? updatedAt;
}

/// Data statistik singkat untuk kartu ringkas di Beranda.
class KiStat {
  const KiStat({
    required this.label, 
    required this.value, 
    required this.icon,
  
  });

  final String label;
  final String value;
  final IconData icon;
}

class DummyData {
  static const List<KiCategory> categories = [
    KiCategory(
      type: KiCategoryType.ebt,
      title: 'EBT',
      subtitle: 'Ekspresi Budaya Tradisional',
      description: 'Ekspresi Budaya Tradisional merupakan bentuk seni dan tradisi yang diwariskan secara turun-temurun dalam suatu komunitas.',
      goals: 'Tujuannya adalah melindungi warisan budaya dan mencegah klaim oleh pihak lain.',
      icon: Icons.palette_outlined,
      accent: Color(0xFF22C55E),
      totalCount: 0,
    ),
    KiCategory(
      type: KiCategoryType.pt,
      title: 'PT',
      subtitle: 'Paten / Teknologi',
      description: 'Pengetahuan Tradisional adalah pengetahuan lokal yang berkembang dan diwariskan antar generasi.',
      goals: 'Tujuannya untuk menjaga hak masyarakat serta mencegah penyalahgunaan.',
      icon: Icons.lightbulb_outline,
      accent: Color(0xFF0EA5E9),
      totalCount: 0,
    ),
    KiCategory(
      type: KiCategoryType.pig,
      title: 'PIG',
      subtitle: 'Potensi Indikasi Geografis',
      description: 'Potensi Indikasi Geografis adalah produk khas daerah yang memiliki kualitas atau ciri tertentu.',
      goals: 'Tujuannya memberikan nilai ekonomi sekaligus melindungi nama dan reputasi daerah.',
      icon: Icons.place_outlined,
      accent: Color(0xFF14B8A6),
      totalCount: 0,
    ),
    KiCategory(
      type: KiCategoryType.sdg,
      title: 'SDG',
      subtitle: 'Sumber Daya Genetik',
      description: 'Sumber Daya Genetik mencakup tumbuhan, hewan, atau mikroorganisme khas suatu daerah.',
      goals: 'Tujuannya melindungi kekayaan hayati dan memastikan pemanfaatannya secara adil.',
      icon: Icons.eco_outlined,
      accent: Color(0xFF84CC16),
      totalCount: 0,
    ),
    KiCategory(
      type: KiCategoryType.ia,
      title: 'Wisata Berbasis kekakyaan intelektual',
      subtitle: 'Wisata Berbasis kekakyaan intelektual',
      description: 'Wisata Berbasis kekakyaan intelektual',
      goals: 'Wisata Berbasis kekakyaan intelektual',
      icon: Icons.apartment_outlined,
      accent: Color(0xFF6366F1),
      totalCount: 0,
    ),
    KiCategory(
      type: KiCategoryType.ig,
      title: 'IG',
      subtitle: 'Indikasi Geografis',
      description: 'Indikasi Geografis',
      goals: 'Indikasi Geografis',
      icon: Icons.verified_outlined,
      accent: Color(0xFFF97316),
      totalCount: 0,
    ),
  ];

  static const List<KiStat> quickStats = [
    KiStat(label: 'Total Data', value: '', icon: Icons.dataset_outlined),
    KiStat(label: 'Kab/Kota', value: '', icon: Icons.map_outlined),
    KiStat(label: 'Terverifikasi', value: '', icon: Icons.verified_outlined),
  ];

  /// Data terbaru (cross-category) untuk section Beranda.
  static const List<KiItem> latestItems = [
    KiItem(
      id: 'EBT-0007',
      category: KiCategoryType.ebt,
      title: 'Tari Pakarena Gantarang',
      owner: 'Komunitas Seni Tradisi',
      location: 'Kab. Gowa',
      year: 2022,
      status: 'Terverifikasi',
      summary: 'Karya tari tradisional yang menjadi identitas budaya dan ditampilkan '
          'dalam upacara adat.\nDokumentasi meliputi gerak, busana, musik pengiring, '
          'dan konteks sosial.',
      tags: ['Seni', 'Tari', 'Budaya'],
    ),
    KiItem(
      id: 'PT-0142',
      category: KiCategoryType.pt,
      title: 'Alat Pengering Rumput Laut Hemat Energi',
      owner: 'UMKM Bahari Makassar',
      location: 'Kota Makassar',
      year: 2023,
      status: 'Dalam Proses',
      summary: 'Prototipe alat pengering dengan aliran udara terarah untuk '
          'mempercepat proses dan menjaga kualitas.\nCocok untuk sentra '
          'produksi pesisir.',
      tags: ['Teknologi', 'UMKM'],
    ),
    KiItem(
      id: 'IG-0003',
      category: KiCategoryType.ig,
      title: 'Kopi Kalosi Enrekang',
      owner: 'Asosiasi Petani Kopi',
      location: 'Kab. Enrekang',
      year: 2021,
      status: 'Terdaftar',
      summary: 'Kopi arabika dengan karakter rasa khas dan profil aroma yang '
          'dipengaruhi ketinggian serta proses pascapanen.\nMenjadi '
          'komoditas unggulan daerah.',
      tags: ['Pertanian', 'Komoditas', 'IG'],
    ),
  ];

  /// Data per kategori untuk kebutuhan list.
  static const List<KiItem> items = [
    KiItem(
      id: 'EBT-0001',
      category: KiCategoryType.ebt,
      title: 'Tenun Sekomandi',
      owner: 'Perajin Lokal',
      location: 'Kab. Polewali (Perbatasan)',
      year: 2020,
      status: 'Terverifikasi',
      summary: 'Motif tenun dengan pola geometris khas dan teknik pewarnaan '
          'tradisional.\nDipakai dalam upacara adat dan acara keluarga.',
      tags: ['Kerajinan', 'Tenun'],
    ),
    KiItem(
      id: 'EBT-0002',
      category: KiCategoryType.ebt,
      title: 'Sastra Lisan Sureq',
      owner: 'Tokoh Adat',
      location: 'Kab. Wajo',
      year: 2019,
      status: 'Terverifikasi',
      summary: 'Naskah dan tradisi tutur yang diwariskan lintas generasi.\nMemuat '
          'nilai moral, sejarah, dan identitas komunitas.',
      tags: ['Sastra', 'Lisan'],
    ),
    KiItem(
      id: 'PT-0101',
      category: KiCategoryType.pt,
      title: 'Metode Filtrasi Air Payau untuk Tambak',
      owner: 'Kelompok Riset Kampus',
      location: 'Kab. Pangkep',
      year: 2022,
      status: 'Terdaftar',
      summary: 'Metode filtrasi bertingkat untuk menurunkan salinitas dan '
          'kandungan organik.\nMeningkatkan produktivitas budidaya.',
      tags: ['Air', 'Budidaya'],
    ),
    KiItem(
      id: 'PIG-0042',
      category: KiCategoryType.pig,
      title: 'Garam Tradisional Jeneponto',
      owner: 'Kelompok Petambak',
      location: 'Kab. Jeneponto',
      year: 2021,
      status: 'Kurasi Data',
      summary: 'Potensi indikasi geografis dari proses produksi garam dengan '
          'teknik lokal.\nFokus pada karakter rasa dan kandungan mineral.',
      tags: ['PIG', 'Pesisir'],
    ),
    KiItem(
      id: 'SDG-0021',
      category: KiCategoryType.sdg,
      title: 'Varietas Padi Lokal Aromatik',
      owner: 'Balai Benih',
      location: 'Kab. Sidrap',
      year: 2018,
      status: 'Terverifikasi',
      summary: 'Sumber daya genetik padi dengan aroma khas dan ketahanan terhadap '
          'kondisi tertentu.\nData mencakup profil budidaya dan karakter morfologi.',
      tags: ['SDG', 'Pertanian'],
    ),
    KiItem(
      id: 'IA-0009',
      category: KiCategoryType.ia,
      title: 'Sentra Kerajinan Perak Somba Opu',
      owner: 'Koperasi Perajin',
      location: 'Kab. Gowa',
      year: 2020,
      status: 'Terverifikasi',
      summary: 'Klaster industri kreatif yang memproduksi perhiasan dan aksesori '
          'perak.\nMemiliki pola desain yang khas dan rantai pasok lokal.',
      tags: ['Industri', 'Kreatif'],
    ),
    KiItem(
      id: 'IG-0006',
      category: KiCategoryType.ig,
      title: 'Sagu Luwu',
      owner: 'Kelompok Tani',
      location: 'Kab. Luwu',
      year: 2022,
      status: 'Dalam Proses',
      summary: 'Produk olahan sagu dengan karakter tekstur dan rasa yang '
          'dipengaruhi bahan baku dan proses.\nMenjadi pangan lokal strategis.',
      tags: ['Pangan', 'IG'],
    ),
  ];

  static String categoryLabel(KiCategoryType type) {
    return switch (type) {
      KiCategoryType.ebt => 'EBT',
      KiCategoryType.pt => 'PT',
      KiCategoryType.pig => 'PIG',
      KiCategoryType.sdg => 'SDG',
      KiCategoryType.ia => 'IA',
      KiCategoryType.ig => 'IG',
    };
  }

  static KiCategory categoryOf(KiCategoryType type) {
    return categories.firstWhere((c) => c.type == type);
  }

  static List<KiItem> itemsByCategory(KiCategoryType type) {
    return items.where((i) => i.category == type).toList(growable: false);
  }
}
