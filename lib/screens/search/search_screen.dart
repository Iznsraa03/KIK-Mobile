import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../repositories/search_repository.dart';
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
    final query = _controller.text.trim();

    const suggestions = ['Kopi', 'Tenun', 'Rumput laut', 'Padi', 'Garam'];

    final repo = SearchRepository();

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
                child: FutureBuilder(
                  future: repo.search(q: query, perPage: 20),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return _EmptyState(
                        query: query,
                        subtitle: 'Gagal memuat dari API.\n${snapshot.error}',
                      );
                    }

                    final results = snapshot.data?.data ?? const <KiSearchItem>[];

                    if (results.isEmpty) {
                      return _EmptyState(query: query);
                    }

                    return ListView.separated(
                      itemCount: results.length,
                        separatorBuilder: (_, i) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final item = results[i];
                          final cat = DummyData.categoryOf(item.category);

                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(
                                    item: KiItem(
                                      id: item.id,
                                      category: item.category,
                                      title: item.title,
                                      owner: '-',
                                      location: item.region,
                                      year: 0,
                                      status: item.status,
                                      summary: item.description,
                                      tags: const [],
                                      imagePath: item.image,
                                      createdAt: item.createdAt,
                                    ),
                                  ),
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
                              '${cat.title} • ${item.region} • ${item.status}',
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
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
  const _EmptyState({required this.query, this.subtitle});

  final String query;
  final String? subtitle;

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
            subtitle ?? 'Coba kata kunci lain.',
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
