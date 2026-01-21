import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../repositories/ki_repository.dart';
import '../../repositories/statistics_repository.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/category_card.dart';
import '../../widgets/stat_chip.dart';
import '../about/about_screen.dart';
import '../category/category_list_screen.dart';
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

  // Carousel images from assets/img
  final List<String> _carouselImages = const [
    'assets/img/gambar1.jpg',
    'assets/img/gambar2.jpg',
    'assets/img/gambar3.jpg',
    'assets/img/gambar4.jpeg',
    'assets/img/gambar5.jpg',
    'assets/img/gambar6.jpg',
  ];

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Wisata Kekayaan\nIntelektual Sulsel',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                            ),
                    ),
                    Image.asset(
                      'assets/logo/logo kemenhum.png',
                      height: 50,

                    ),
                    Image.asset(
                      'assets/logo/logoApps.jpeg',
                      height: 50,

                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Text(
                //   'Prototype UI untuk menampilkan data KI per kategori, statistik singkat, dan data terbaru.',
                //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //         color: cs.onSurfaceVariant,
                //       )
                // ),
                const SizedBox(height: 14),
                HomeImageCarousel(
                  images: _carouselImages,
                ),
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MapScreen()),
                  );
                },
                label: Text('Ayo jelajahi sulsel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
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
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: DummyData.categories.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final c = DummyData.categories[i];
                      final count = totals?[c.type] ?? c.totalCount;

                      return SizedBox(
                        width: 240,
                        child: CategoryCard(
                          title: c.title,
                          subtitle: c.subtitle,
                          description: c.description,
                          goals: c.goals,
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
                        ),
                      );
                    },
                  ),
                ),
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

class HomeImageCarousel extends StatefulWidget {
  const HomeImageCarousel({
    super.key,
    required this.images,
    this.height = 180,
    this.autoSlideInterval = const Duration(seconds: 4),
  });

  final List<String> images;
  final double height;
  final Duration autoSlideInterval;

  @override
  State<HomeImageCarousel> createState() => _HomeImageCarouselState();
}

class _HomeImageCarouselState extends State<HomeImageCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    // Only start timer if there is more than 1 image.
    if (widget.images.length > 1) {
      _timer = Timer.periodic(widget.autoSlideInterval, (_) {
        if (!mounted) return;
        final next = (_index + 1) % widget.images.length;
        _controller.animateToPage(
          next,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (widget.images.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                return Image.asset(
                  widget.images[i],
                  fit: BoxFit.cover,
                );
              },
            ),
            // subtle gradient overlay for text/indicator contrast
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: 0.20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Center(
                child: _CarouselDots(
                  count: widget.images.length,
                  index: _index,
                  activeColor: cs.secondary,
                  inactiveColor: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (i) {
          final selected = i == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 7,
            width: selected ? 18 : 7,
            decoration: BoxDecoration(
              color: selected ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );
  }
}

