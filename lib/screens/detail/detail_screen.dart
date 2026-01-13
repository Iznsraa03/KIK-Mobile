import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/dummy_data.dart';
import '../../repositories/ki_repository.dart';
import 'video_player_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.item});

  final KiItem item;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final Future<KiItem> _future;

  void _openImageViewer(String imageUrl) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withValues(alpha: 0.92),
      pageBuilder: (context, animation, secondaryAnimation) {
        final cs = Theme.of(context).colorScheme;

        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(
                  child: InteractiveViewer(
                    minScale: 0.9,
                    maxScale: 4.0,
                    child: Center(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.broken_image_outlined,
                                  color: cs.onSurfaceVariant,
                                  size: 42,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Gagal memuat gambar',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton.filled(
                    tooltip: 'Tutup',
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _future = KiRepository().getDetail(widget.item.category, widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FutureBuilder<KiItem>(
      future: _future,
      builder: (context, snapshot) {
        // fallback: jika gagal, tetap tampilkan data dari list.
        final item = snapshot.data ?? widget.item;
        final category = DummyData.categoryOf(item.category);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 220,
                backgroundColor: cs.surface,
                foregroundColor: cs.onSurface,
                // actions: [
                //   IconButton(
                //     tooltip: 'Share (UI)',
                //     onPressed: () {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(content: Text('Share UI (prototype).')),
                //       );
                //     },
                //     icon: const Icon(Icons.ios_share_rounded),
                //   ),
                //   const SizedBox(width: 4),
                // ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Header image from API (if absolute URL available).
                      if (item.imagePath != null &&
                          (item.imagePath!.startsWith('http://') ||
                              item.imagePath!.startsWith('https://')))
                        GestureDetector(
                          onTap: () => _openImageViewer(item.imagePath!),
                          child: Image.network(
                            item.imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Bantu debugging (khususnya Flutter Web / CORS / mixed content)
                              debugPrint(
                                '[Image] Failed to load header image: ${item.imagePath} | error: $error',
                              );
                              return Container(
                                color: cs.surfaceContainerHighest,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: cs.onSurfaceVariant,
                                ),
                              );
                            },
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          //   colors: [
                          //     category.accent.withValues(alpha: 0.95),
                          //     category.accent.withValues(alpha: 0.55),
                          //     cs.surface,
                          //   ],
                          //   stops: const [0.0, 0.55, 1.0],
                          // ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Row(
                            children: [
                              // Container(
                              //   height: 56,
                              //   width: 56,
                              //   decoration: BoxDecoration(
                              //     color: Colors.white.withValues(alpha: 0.18),
                              //     borderRadius: BorderRadius.circular(18),
                              //     border: Border.all(
                              //       color: Colors.white.withValues(alpha: 0.22),
                              //     ),
                              //   ),
                              //   child: Icon(category.icon, color: Colors.white),
                              // ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.50),
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Text(
                                        category.subtitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Colors.white.withValues(
                                                alpha: 0.92,
                                              ),
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ),
                                    if (item.imagePath != null &&
                                        !(item.imagePath!.startsWith(
                                              'http://',
                                            ) ||
                                            item.imagePath!.startsWith(
                                              'https://',
                                            )))
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Gambar: ${item.imagePath}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.white.withValues(
                                                  alpha: 0.86,
                                                ),
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // _Badge(
                          //   label: item.status,
                          //   background: cs.secondaryContainer,
                          //   foreground: cs.onSecondaryContainer,
                          // ),
                          // _Badge(
                          //   label: item.id,
                          //   background: cs.surfaceContainerHighest,
                          //   foreground: cs.onSurface,
                          // ),
                          _Badge(
                            label: item.location,
                            background: Colors.white,
                            foreground: category.accent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _InfoCard(
                        title: 'Ringkasan',
                        child: Text(
                          item.summary,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: cs.onSurfaceVariant,
                                height: 1.4,
                              ),
                        ),
                      ),
                      if (item.content != null &&
                          item.content!.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _InfoCard(
                          title: 'Isi',
                          child: Text(
                            item.content!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  height: 1.5,
                                ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      _InfoExpandable(
                        title: 'Informasi',
                        children: [
                          if (item.community != null &&
                              item.community!.isNotEmpty)
                            _InfoRow(
                              label: 'Komunitas',
                              value: item.community!,
                            ),
                          _InfoRow(label: 'Pemilik', value: item.owner),
                          _InfoRow(
                            label: 'Tahun',
                            value: item.year == 0 ? '-' : '${item.year}',
                          ),
                          _InfoRow(label: 'Kategori', value: category.title),
                          if (item.createdAt != null)
                            _InfoRow(
                              label: 'Dibuat',
                              value: item.createdAt!.toLocal().toString(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (item.tags.isNotEmpty)
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

                      if (item.media != null && item.media!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _MediaSection(
                          mediaUrls: item.media!,
                          onOpenImage: _openImageViewer,
                        ),
                      ],

                      if (item.resourceLinks != null &&
                          item.resourceLinks!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _InfoExpandable(
                          title: 'Berita',
                          children: [
                            for (final link in item.resourceLinks!)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: InkWell(
                                  onTap: () async {
                                    final raw = link.trim();
                                    final withScheme = (raw.startsWith('http://') ||
                                            raw.startsWith('https://'))
                                        ? raw
                                        : 'https://$raw';
                                    final uri = Uri.tryParse(withScheme);

                                    if (uri == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Link tidak valid: $raw')),
                                      );
                                      return;
                                    }

                                    try {
                                      final ok = await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );

                                      if (!ok && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Gagal membuka link: $raw')),
                                        );
                                      }
                                    } on PlatformException catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Tidak dapat membuka browser (plugin iOS belum siap).\n${e.code}',
                                          ),
                                        ),
                                      );
                                    } catch (_) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Gagal membuka link: $raw')),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.newspaper_rounded,
                                        color: cs.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          link,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                decoration: TextDecoration.underline,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Aksi UI (prototype).'),
                            ),
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
      },
    );
  }
}

class _MediaSection extends StatelessWidget {
  const _MediaSection({required this.mediaUrls, required this.onOpenImage});

  final List<String> mediaUrls;
  final ValueChanged<String> onOpenImage;

  bool _isVideo(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.m3u8') ||
        lower.endsWith('.webm');
  }

  bool _isImage(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final videos = mediaUrls.where(_isVideo).toList(growable: false);
    final images = mediaUrls.where(_isImage).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (videos.isNotEmpty)
          _InfoCard(
            title: 'Video',
            child: Column(
              children: [
                for (final v in videos)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => VideoPlayerScreen(url: v),
                          ),
                        );
                      },
                      child: Ink(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: cs.outlineVariant.withValues(alpha: 0.7),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 42,
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.play_circle_fill_rounded,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Putar video',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (videos.isNotEmpty && images.isNotEmpty) const SizedBox(height: 12),
        if (images.isNotEmpty)
          _InfoCard(
            title: 'Gambar',
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Grid ringan tanpa nested scroll.
                final crossAxisCount = constraints.maxWidth < 360 ? 2 : 3;
                final size =
                    (constraints.maxWidth - (crossAxisCount - 1) * 10) /
                    crossAxisCount;

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final img in images)
                      GestureDetector(
                        onTap: () => onOpenImage(img),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            img,
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: size,
                                height: size,
                                color: cs.surfaceContainerHighest,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: cs.onSurfaceVariant,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

        // Jika ada media yang tidak terklasifikasi, tampilkan jumlah saja (tanpa URL).
        if (mediaUrls.length != videos.length + images.length) ...[
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Media lainnya',
            child: Text(
              '${mediaUrls.length - videos.length - images.length} file',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ],
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
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
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
