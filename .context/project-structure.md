# Project structure overview
```
// Structure of documents
└── lib/
    └── data/
        ├── dummy_data.dart
    └── main.dart
    └── screens/
        ├── about/
        │   ├── about_screen.dart
        ├── category/
        │   ├── category_list_screen.dart
        ├── detail/
        │   ├── detail_screen.dart
        ├── home/
        │   ├── home_screen.dart
        ├── map/
        │   ├── map_screen.dart
        ├── search/
        │   ├── search_screen.dart
        ├── splash/
        │   └── splash_screen.dart
    └── widgets/
        └── app_section_header.dart
        └── category_card.dart
        └── stat_chip.dart

```
###  Path: `/lib/data/dummy_data.dart`

```dart
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
    required this.icon,
    required this.accent,
    required this.totalCount,
  });

  final KiCategoryType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final int totalCount;
}

/// Model item KI untuk kebutuhan list & detail.
class KiItem {
  const KiItem({
    required this.id,
    required this.category,
    required this.title,
    required this.owner,
    required this.location,
    required this.year,
    required this.status,
    required this.summary,
    required this.tags,
  });

  final String id;
  final KiCategoryType category;
  final String title;
  final String owner;
  final String location;
  final int year;
  final String status; // contoh: Terdaftar / Dalam Proses / Terverifikasi
  final String summary;
  final List<String> tags;
}

/// Data statistik singkat untuk kartu ringkas di Beranda.
class KiStat {
  const KiStat({required this.label, required this.value, required this.icon});

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
      icon: Icons.palette_outlined,
      accent: Color(0xFF22C55E),
      totalCount: 128,
    ),
    KiCategory(
      type: KiCategoryType.pt,
      title: 'PT',
      subtitle: 'Paten / Teknologi',
      icon: Icons.lightbulb_outline,
      accent: Color(0xFF0EA5E9),
      totalCount: 64,
    ),
    KiCategory(
      type: KiCategoryType.pig,
      title: 'PIG',
      subtitle: 'Potensi Indikasi Geografis',
      icon: Icons.place_outlined,
      accent: Color(0xFF14B8A6),
      totalCount: 41,
    ),
    KiCategory(
      type: KiCategoryType.sdg,
      title: 'SDG',
      subtitle: 'Sumber Daya Genetik',
      icon: Icons.eco_outlined,
      accent: Color(0xFF84CC16),
      totalCount: 52,
    ),
    KiCategory(
      type: KiCategoryType.ia,
      title: 'IA',
      subtitle: 'Industri & Aset',
      icon: Icons.apartment_outlined,
      accent: Color(0xFF6366F1),
      totalCount: 37,
    ),
    KiCategory(
      type: KiCategoryType.ig,
      title: 'IG',
      subtitle: 'Indikasi Geografis',
      icon: Icons.verified_outlined,
      accent: Color(0xFFF97316),
      totalCount: 18,
    ),
  ];

  static const List<KiStat> quickStats = [
    KiStat(label: 'Total Data', value: '340', icon: Icons.dataset_outlined),
    KiStat(label: 'Kab/Kota', value: '24', icon: Icons.map_outlined),
    KiStat(label: 'Terverifikasi', value: '196', icon: Icons.verified_outlined),
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

```
###  Path: `/lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const JelajahKiSulselApp());
}

class JelajahKiSulselApp extends StatelessWidget {
  const JelajahKiSulselApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF16A34A); // green
    const tertiary = Color(0xFF0EA5E9); // blue

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ).copyWith(tertiary: tertiary),
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: base.colorScheme.onSurface);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jelajah KI Sulsel',
      theme: base.copyWith(
        textTheme: textTheme,
        scaffoldBackgroundColor: base.colorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: base.colorScheme.surface,
          foregroundColor: base.colorScheme.onSurface,
          centerTitle: false,
          titleTextStyle: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          color: base.colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

```
###  Path: `/lib/screens/about/about_screen.dart`

```dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primary.withValues(alpha: 0.18),
                  cs.tertiary.withValues(alpha: 0.14),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(Icons.travel_explore_rounded, color: cs.onPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jelajah KI Sulsel',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prototype UI/UX untuk eksplorasi data Kekayaan Intelektual Sulawesi Selatan.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const _InfoTile(
            icon: Icons.verified_outlined,
            title: 'Versi',
            subtitle: '1.0.0 (UI Mockup)',
          ),
          const SizedBox(height: 10),
          const _InfoTile(
            icon: Icons.code_rounded,
            title: 'Pengembang',
            subtitle: 'Tim UI/UX & Flutter (Prototype)',
          ),
          const SizedBox(height: 10),
          const _InfoTile(
            icon: Icons.info_outline_rounded,
            title: 'Catatan',
            subtitle:
                'Aplikasi ini tidak menggunakan API, backend, database, maupun autentikasi. Seluruh data bersifat dummy/statis.',
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

```
###  Path: `/lib/screens/category/category_list_screen.dart`

```dart
import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../detail/detail_screen.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key, required this.category});

  final KiCategory category;

  @override
  Widget build(BuildContext context) {
    final items = DummyData.itemsByCategory(category.type);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        actions: [
          IconButton(
            tooltip: 'Filter (UI)',
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final item = items[i];

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DetailScreen(item: item)),
              );
            },
            child: Ink(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.7)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: category.accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.accent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${item.location} • ${item.owner}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _MetaPill(
                              label: item.status,
                              color: cs.secondaryContainer,
                              textColor: cs.onSecondaryContainer,
                            ),
                            const SizedBox(width: 8),
                            _MetaPill(
                              label: '${item.year}',
                              color: cs.surfaceContainerHighest,
                              textColor: cs.onSurface,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
      ),
    );
  }
}

```
###  Path: `/lib/screens/detail/detail_screen.dart`

```dart
import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.item});

  final KiItem item;

  @override
  Widget build(BuildContext context) {
    final category = DummyData.categoryOf(item.category);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: cs.surface,
            foregroundColor: cs.onSurface,
            actions: [
              IconButton(
                tooltip: 'Share (UI)',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share UI (prototype).')),
                  );
                },
                icon: const Icon(Icons.ios_share_rounded),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      category.accent.withValues(alpha: 0.95),
                      category.accent.withValues(alpha: 0.55),
                      cs.surface,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Icon(category.icon, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category.subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Badge(
                        label: item.status,
                        background: cs.secondaryContainer,
                        foreground: cs.onSecondaryContainer,
                      ),
                      _Badge(
                        label: item.id,
                        background: cs.surfaceContainerHighest,
                        foreground: cs.onSurface,
                      ),
                      _Badge(
                        label: item.location,
                        background: category.accent.withValues(alpha: 0.14),
                        foreground: category.accent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    title: 'Ringkasan',
                    child: Text(
                      item.summary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            height: 1.4,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoExpandable(
                    title: 'Informasi',
                    children: [
                      _InfoRow(label: 'Pemilik', value: item.owner),
                      _InfoRow(label: 'Tahun', value: '${item.year}'),
                      _InfoRow(label: 'Kategori', value: category.title),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoExpandable(
                    title: 'Tag',
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in item.tags)
                            _Badge(
                              label: tag,
                              background: cs.primaryContainer,
                              foreground: cs.onPrimaryContainer,
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Aksi UI (prototype).')),
                      );
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Simpan (UI)'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _InfoExpandable extends StatelessWidget {
  const _InfoExpandable({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          children: children,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

```
###  Path: `/lib/screens/home/home_screen.dart`

```dart
import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/category_card.dart';
import '../../widgets/stat_chip.dart';
import '../about/about_screen.dart';
import '../category/category_list_screen.dart';
import '../detail/detail_screen.dart';
import '../map/map_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeTab(),
      const SearchScreen(),
      const MapScreen(),
      const AboutScreen(),
    ];

    return Scaffold(
      body: pages[_navIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Cari',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Wilayah',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info_rounded),
            label: 'Tentang',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: cs.surface,
          centerTitle: false,
          title: const Text('Jelajah KI Sulsel'),
          actions: [
            IconButton(
              tooltip: 'Pencarian',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              icon: const Icon(Icons.search_rounded),
            ),
            const SizedBox(width: 4),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eksplorasi Kekayaan\nIntelektual Sulsel',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Prototype UI untuk menampilkan data KI per kategori, statistik singkat, dan data terbaru.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 14),
                _QuickStatsRow(stats: DummyData.quickStats),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          sliver: SliverToBoxAdapter(
            child: AppSectionHeader(
              title: 'Kategori',
              subtitle: 'Pilih modul untuk melihat daftar data.',
              actionLabel: 'Lihat semua',
              onAction: () {
                // UX: untuk prototype, kita arahkan ke kategori pertama.
                final first = DummyData.categories.first;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoryListScreen(category: first),
                  ),
                );
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverGrid.builder(
            itemCount: DummyData.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.06,
            ),
            itemBuilder: (context, i) {
              final c = DummyData.categories[i];
              return CategoryCard(
                title: c.title,
                subtitle: c.subtitle,
                icon: c.icon,
                accent: c.accent,
                count: c.totalCount,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CategoryListScreen(category: c),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          sliver: SliverToBoxAdapter(
            child: AppSectionHeader(
              title: 'Data terbaru',
              subtitle: 'Update terakhir (dummy data).',
              actionLabel: 'Cari',
              onAction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          sliver: SliverList.separated(
            itemCount: DummyData.latestItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final item = DummyData.latestItems[i];
              final category = DummyData.categoryOf(item.category);

              return _LatestItemCard(
                categoryAccent: category.accent,
                categoryLabel: category.title,
                item: item,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(item: item),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow({required this.stats});

  final List<KiStat> stats;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final s in stats) ...[
            StatChip(label: s.label, value: s.value, icon: s.icon),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _LatestItemCard extends StatelessWidget {
  const _LatestItemCard({
    required this.categoryAccent,
    required this.categoryLabel,
    required this.item,
    this.onTap,
  });

  final Color categoryAccent;
  final String categoryLabel;
  final KiItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryAccent.withOpacity(0.95),
                    categoryAccent.withOpacity(0.55),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.image_rounded,
                color: Colors.white.withOpacity(0.92),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: categoryAccent.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          categoryLabel,
                          style: t.labelLarge?.copyWith(
                            color: categoryAccent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${item.year}',
                        style:
                            t.labelLarge?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.location} • ${item.status}',
                    style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```
###  Path: `/lib/screens/map/map_screen.dart`

```dart
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int? _selectedMarker;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Eksplorasi Wilayah')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Peta (mockup)',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.map_rounded,
                            size: 44,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Peta statis untuk presentasi UI',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _Marker(
                    left: 54,
                    top: 74,
                    label: 'Makassar',
                    selected: _selectedMarker == 0,
                    onTap: () => _openSheet(0, 'Kota Makassar', '12 data terbaru'),
                  ),
                  _Marker(
                    left: 180,
                    top: 120,
                    label: 'Gowa',
                    selected: _selectedMarker == 1,
                    onTap: () => _openSheet(1, 'Kab. Gowa', '8 data terbaru'),
                  ),
                  _Marker(
                    left: 120,
                    top: 190,
                    label: 'Enrekang',
                    selected: _selectedMarker == 2,
                    onTap: () => _openSheet(2, 'Kab. Enrekang', '4 data terbaru'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSheet(int markerId, String title, String subtitle) {
    setState(() => _selectedMarker = markerId);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.list_alt_rounded),
                label: const Text('Lihat data (UI)'),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      if (!mounted) return;
      setState(() => _selectedMarker = null);
    });
  }
}

class _Marker extends StatelessWidget {
  const _Marker({
    required this.left,
    required this.top,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final double left;
  final double top;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? cs.primary : cs.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? cs.primary
                  : cs.outlineVariant.withValues(alpha: 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 18,
                color: selected ? cs.onPrimary : cs.primary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: selected ? cs.onPrimary : cs.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```
###  Path: `/lib/screens/search/search_screen.dart`

```dart
import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../detail/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final query = _controller.text.trim().toLowerCase();

    const suggestions = ['Kopi', 'Tenun', 'Rumput laut', 'Padi', 'Garam'];

    final results = DummyData.items
        .where((e) {
          if (query.isEmpty) return false;
          return e.title.toLowerCase().contains(query) ||
              e.location.toLowerCase().contains(query) ||
              e.tags.any((t) => t.toLowerCase().contains(query));
        })
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari judul, tag, atau wilayah…',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.55),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (query.isEmpty)
              _SuggestionGrid(
                suggestions: suggestions,
                onTap: (value) {
                  _controller.text = value;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                  setState(() {});
                },
              )
            else
              Expanded(
                child: results.isEmpty
                    ? _EmptyState(query: query)
                    : ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final item = results[i];
                          final cat = DummyData.categoryOf(item.category);

                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(item: item),
                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: cs.outlineVariant.withValues(alpha: 0.7),
                              ),
                            ),
                            tileColor: cs.surface,
                            leading: Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                color: cat.accent.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(cat.icon, color: cat.accent),
                            ),
                            title: Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            subtitle: Text(
                              '${cat.title} • ${item.location} • ${item.status}',
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionGrid extends StatelessWidget {
  const _SuggestionGrid({required this.suggestions, required this.onTap});

  final List<String> suggestions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saran pencarian',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final s in suggestions)
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => onTap(s),
                  child: Ink(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          s,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.tips_and_updates_outlined, color: cs.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tip: ketik kata kunci seperti "Kopi", "Tenun", atau nama kabupaten.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 42, color: cs.onSurfaceVariant),
          const SizedBox(height: 10),
          Text(
            'Tidak ada hasil untuk "$query"',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            'Coba kata kunci lain (dummy data).',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

```
###  Path: `/lib/screens/splash/splash_screen.dart`

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Auto-navigate untuk prototype.
    _navTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(opacity: curved, child: child);
          },
          transitionDuration: const Duration(milliseconds: 450),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cs.primary.withOpacity(0.92),
              cs.tertiary.withOpacity(0.88),
              cs.primaryContainer.withOpacity(0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fade.value,
                  child: Transform.scale(scale: _scale.value, child: child),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 84,
                    width: 84,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.travel_explore,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Jelajah KI Sulsel',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Prototype UI/UX Eksplorasi Kekayaan Intelektual',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.86),
                        ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white.withOpacity(0.9),
                      backgroundColor: Colors.white.withOpacity(0.18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

```
###  Path: `/lib/widgets/app_section_header.dart`

```dart
import 'package:flutter/material.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: t.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: Text(actionLabel!),
          ),
      ],
    );
  }
}

```
###  Path: `/lib/widgets/category_card.dart`

```dart
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.count,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final int count;
  final VoidCallback? onTap;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.985 : 1,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: widget.accent.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(widget.icon, color: widget.accent, size: 22),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${widget.count}',
                      style: t.labelLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.title,
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```
###  Path: `/lib/widgets/stat_chip.dart`

```dart
import 'package:flutter/material.dart';

class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: t.labelMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

```