import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../repositories/ki_repository.dart';
import '../detail/detail_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({
    super.key,
    required this.category,
    this.daerahAsal,
    this.search,
    this.status,
  });

  final KiCategory category;
  final String? daerahAsal;
  final String? search;
  final String? status;

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  static const int _perPage = 15;

  final _repo = KiRepository();
  final _scrollController = ScrollController();

  int _page = 1;

  void _goToPage(int newPage) {
    if (newPage < 1) return;
    if (newPage == _page) return;
    setState(() => _page = newPage);
    // Kembalikan scroll ke atas agar UX enak saat pindah halaman.
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final category = widget.category;
    final daerahAsal = widget.daerahAsal;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          daerahAsal == null ? category.title : '${category.title} • $daerahAsal',
        ),
      ),
      body: FutureBuilder(
        future: _repo.getCategoryItems(
          category.type,
          daerahAsal: widget.daerahAsal,
          search: widget.search,
          status: widget.status,
          page: _page,
          perPage: _perPage,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorState(
              message: 'Gagal memuat data dari API.\n${snapshot.error}',
              onRetry: () => setState(() {}),
            );
          }

          final res = snapshot.data;
          final items = res?.data ?? const <KiItem>[];

          final meta = res?.meta;
          final currentPage = meta?.currentPage ?? _page;
          final lastPage = meta?.lastPage ?? currentPage;
          final total = meta?.total;

          if (items.isEmpty) {
            return const Center(child: Text('Data kosong.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: items.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final item = items[i];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(item: item),
                          ),
                        );
                      },
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
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            _ItemPreviewImage(
                              size: 64,
                              borderRadius: 16,
                              imageUrl: item.imagePath,
                              fallbackColor: category.accent.withValues(alpha: 0.14),
                              fallbackIcon: category.icon,
                              fallbackIconColor: category.accent,
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
                                      // _MetaPill(
                                      //   label: item.status,
                                      //   color: cs.secondaryContainer,
                                      //   textColor: cs.onSecondaryContainer,
                                      // ),
                                      const SizedBox(width: 8),
                                      _MetaPill(
                                        label: item.year == 0 ? '-' : '${item.year}',
                                        color: cs.surfaceContainerHighest,
                                        textColor: cs.onSurface,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: cs.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _PaginationBar(
                currentPage: currentPage,
                lastPage: lastPage,
                total: total,
                onPrev: currentPage > 1 ? () => _goToPage(currentPage - 1) : null,
                onNext:
                    currentPage < lastPage ? () => _goToPage(currentPage + 1) : null,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ItemPreviewImage extends StatelessWidget {
  const _ItemPreviewImage({
    required this.size,
    required this.borderRadius,
    required this.imageUrl,
    required this.fallbackColor,
    required this.fallbackIcon,
    required this.fallbackIconColor,
  });

  final double size;
  final double borderRadius;
  final String? imageUrl;
  final Color fallbackColor;
  final IconData fallbackIcon;
  final Color fallbackIconColor;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    final hasUrl = url != null && url.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: size,
        width: size,
        color: fallbackColor,
        child: hasUrl
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(fallbackIcon, color: fallbackIconColor, size: 28);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: fallbackIconColor,
                      ),
                    ),
                  );
                },
              )
            : Icon(fallbackIcon, color: fallbackIconColor, size: 28),
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

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.lastPage,
    required this.onPrev,
    required this.onNext,
    this.total,
  });

  final int currentPage;
  final int lastPage;
  final int? total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // final info = total == null
    //     ? 'Halaman $currentPage / $lastPage'
    //     : 'Halaman $currentPage / $lastPage • Total $total';

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(
            top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.7)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton.tonalIcon(
              onPressed: onPrev,
              icon: const Icon(Icons.chevron_left_rounded),
              label: const Text('Sebelumnya'),
            ),
            // const SizedBox(width: 12),
            // Expanded(
            //   child: Text(
            //     info,
            //     textAlign: TextAlign.center,
            //     style: Theme.of(context)
            //         .textTheme
            //         .labelLarge
            //         ?.copyWith(color: cs.onSurfaceVariant),
            //   ),
            // ),
            const SizedBox(width: 12),
            FilledButton.tonalIcon(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right_rounded),
              label: const Text('Berikutnya'),
            ),
          ],
        ),
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
