import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.description,
    this.goals,
    required this.icon,
    required this.accent,
    required this.count,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? description;
  final String? goals;
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
          height: 300,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(alpha: 0.14),
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
                style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant, fontWeight: FontWeight.bold),
              ),
              if (widget.description != null && widget.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(widget.description!, style: const TextStyle(fontSize: 10)),
              ],
              if (widget.goals != null && widget.goals!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(widget.goals!, style: const TextStyle(fontSize: 10)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
