import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final PageController _controller;
  int _index = 0;

  final List<_WelcomePageData> _pages = const [
    _WelcomePageData(
      imageAsset: 'assets/welcome/mobile.png',
      title: 'Kemudahan Akses',
      description:
          'Aplikasi dapat diakses dengan mudah kapan saja dan di mana saja melalui perangkat mobile.',
    ),
    _WelcomePageData(
      imageAsset: 'assets/welcome/searching.png',
      title: 'Cari Budaya Daerah',
      description:
          'Temukan informasi kebudayaan dari berbagai daerah dengan fitur pencarian yang cepat dan mudah.',
    ),
    _WelcomePageData(
      imageAsset: 'assets/welcome/travel.png',
      title: 'Jelajahi Sebelum Berangkat',
      description:
          'Lihat dan pelajari kebudayaan daerah tujuan sebelum kamu benar-benar menjelajahinya.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _next() async {
    final next = _index + 1;
    if (next >= _pages.length) {
      _goToHome();
      return;
    }

    await _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cs.primary.withValues(alpha: 0.10),
              cs.surface,
              cs.secondary.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: _goToHome,
                      child: const Text('Lewati'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    return _WelcomePageItem(data: _pages[i]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    _DotsIndicator(
                      count: _pages.length,
                      index: _index,
                      activeColor: cs.primary,
                      inactiveColor: cs.onSurfaceVariant.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLast ? _goToHome : _next,
                        child: Text(isLast ? 'Mulai Jelajah' : 'Lanjut'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedOpacity(
                      opacity: isLast ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 180),
                      child: Text(
                        'Geser untuk melihat fitur berikutnya',
                        style: t.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
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
    );
  }
}

class _WelcomePageData {
  const _WelcomePageData({
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  final String imageAsset;
  final String title;
  final String description;
}

class _WelcomePageItem extends StatelessWidget {
  const _WelcomePageItem({required this.data});

  final _WelcomePageData data;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, c) {
        final maxW = c.maxWidth;
        final maxH = c.maxHeight;

        // Responsive image sizing.
        final imageSize = (maxW * 0.72).clamp(220.0, 360.0);

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                height: (maxH * 0.42).clamp(220.0, 360.0),
                alignment: Alignment.center,
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: cs.outlineVariant),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    data.imageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: t.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  data.description,
                  textAlign: TextAlign.center,
                  style: t.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: cs.onSurfaceVariant,
                    height: 1.45,
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

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: selected ? 22 : 8,
          decoration: BoxDecoration(
            color: selected ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
