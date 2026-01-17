import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../category/category_list_screen.dart';
import 'map_models.dart';
import 'map_repository.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Future<List<RegionStat>> _future;

  @override
  void initState() {
    super.initState();
    _future = MapRepository().getRegionStats();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eksplorasi Wilayah'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => setState(() {
              _future = MapRepository().getRegionStats();
            }),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<List<RegionStat>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return _ErrorState(
                      message: 'Gagal memuat data wilayah dari API.\n${snapshot.error}',
                      onRetry: () => setState(() {
                        _future = MapRepository().getRegionStats();
                      }),
                    );
                  }

                  final stats = snapshot.data ?? const <RegionStat>[];

                  if (stats.isEmpty) {
                    return const Center(child: Text('Belum ada data wilayah.'));
                  }

                  return ListView.separated(
                    itemCount: stats.length,
                    separatorBuilder: (_, i) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final s = stats[i];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _openRegionSheet(s),
                        child: Ink(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: cs.outlineVariant.withValues(alpha: 0.7),
                            ),
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
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  color: cs.primaryContainer,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.daerahAsal,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Total: ${s.total} data',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: cs.onSurfaceVariant,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.chevron_right_rounded,
                                  color: cs.onSurfaceVariant),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openRegionSheet(RegionStat stat) {
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
                stat.daerahAsal,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                'Total ${stat.total} data (gabungan kategori)',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final entry in stat.perCategory.entries)
                    _CategoryActionChip(
                      category: DummyData.categoryOf(entry.key),
                      count: entry.value,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(this.context).push(
                          MaterialPageRoute(
                            builder: (_) => CategoryListScreen(
                              category: DummyData.categoryOf(entry.key),
                              daerahAsal: stat.daerahAsal,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryActionChip extends StatelessWidget {
  const _CategoryActionChip({
    required this.category,
    required this.count,
    required this.onTap,
  });

  final KiCategory category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon, size: 18, color: category.accent),
            const SizedBox(width: 8),
            Text(
              '${category.title} ($count)',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 42),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
