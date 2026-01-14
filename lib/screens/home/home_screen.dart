import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../repositories/ki_repository.dart';
import '../../repositories/statistics_repository.dart';
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

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  late Future<Map<KiCategoryType, int>> _totalsFuture;

  @override
  void initState() {
    super.initState();
    _totalsFuture = _loadTotals();
  }

  Future<Map<KiCategoryType, int>> _loadTotals() async {
    final repo = KiRepository();
    final futures = DummyData.categories.map((c) async {
      final total = await repo.getCategoryTotalCount(c.type);
      return MapEntry(c.type, total);
    });
    final entries = await Future.wait(futures);
    return {for (final e in entries) e.key: e.value};
  }

  @override
  Widget build(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: const Color.fromARGB(117, 255, 255, 255),
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
                  'Jelajah Kekayaan\nIntelektual Sulsel',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                ),
                const SizedBox(height: 10),
                // Text(
                //   'Prototype UI untuk menampilkan data KI per kategori, statistik singkat, dan data terbaru.',
                //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //         color: cs.onSurfaceVariant,
                //       )
                // ),
                const SizedBox(height: 14),
                FutureBuilder<Map<String, int>>(
                  future: StatisticsRepository().getOverallCounts(),
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    final total = data?['total'];
                    final kabKota = 24; // tidak ada endpoint khusus; tetap dummy
                    // final verified = null; // perlu definisi status "terverifikasi" dari backend

                    final stats = <KiStat>[
                      KiStat(
                        label: 'Total Data',
                        value: total?.toString() ?? '…',
                        icon: Icons.dataset_outlined,
                        
                      ),
                      KiStat(
                        label: 'Kab/Kota',
                        value: '$kabKota',
                        icon: Icons.map_outlined,
                      ),
                      // KiStat(
                      //   label: 'Terverifikasi',
                      //   value: verified?.toString() ?? '—',
                      //   icon: Icons.verified_outlined,
                      // ),
                    ];

                    return _QuickStatsRow(stats: stats);
                  },
                ),
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
            ),
          ),
        ),
        FutureBuilder<Map<KiCategoryType, int>>(
          future: _totalsFuture,
          builder: (context, snapshot) {
            final totals = snapshot.data;

            return SliverPadding(
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
                  final count = totals?[c.type] ?? c.totalCount;

                  return CategoryCard(
                    title: c.title,
                    subtitle: c.subtitle,
                    icon: c.icon,
                    accent: c.accent,
                    count: count,
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
            );
          },
        ),
        SliverPadding(padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),sliver: SliverToBoxAdapter(child: SizedBox(height: 10,),),)
        // SliverPadding(
        //   padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
        //   sliver: SliverToBoxAdapter(
        //     child: AppSectionHeader(
        //       title: 'Data terbaru',
        //       subtitle: 'Update terakhir (dummy data).',
        //       actionLabel: 'Cari',
        //       onAction: () {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(builder: (_) => const SearchScreen()),
        //         );
        //       },
        //     ),
        //   ),
        // ),
        // SliverPadding(
        //   padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        //   sliver: SliverList.separated(
        //     itemCount: DummyData.latestItems.length,
        //     separatorBuilder: (_, i) => const SizedBox(height: 12),
        //     itemBuilder: (context, i) {
        //       final item = DummyData.latestItems[i];
        //       final category = DummyData.categoryOf(item.category);

        //       return _LatestItemCard(
        //         categoryAccent: category.accent,
        //         categoryLabel: category.title,
        //         item: item,
        //         onTap: () {
        //           Navigator.of(context).push(
        //             MaterialPageRoute(
        //               builder: (_) => DetailScreen(item: item),
        //             ),
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ),
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
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryAccent.withValues(alpha: 0.95),
                    categoryAccent.withValues(alpha: 0.55),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.image_rounded,
                color: Colors.white.withValues(alpha: 0.92),
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
                          color: categoryAccent.withValues(alpha: 0.14),
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
