import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../widgets/hover_card.dart';
import '../widgets/responsive_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final isCompact = w < 900;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 40),
        child: ResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.start,
                children: [
                  _Pill(
                    icon: Icons.location_on_outlined,
                    text: 'Homs, Syria',
                  ),
                  _Pill(
                    icon: Icons.auto_awesome_outlined,
                    text: 'Graphic Design • Motion • Video',
                  ),
                  _Pill(
                    icon: Icons.school_outlined,
                    text: 'Computer Science (UoPeople)',
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.12, end: 0),
              const SizedBox(height: 22),

              Text(
                'Design that feels cinematic\n— and works like a system.',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  height: 1.05,
                ),
              ).animate().fadeIn(duration: 520.ms, delay: 120.ms).slideY(begin: 0.12, end: 0),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  'I build clean, high-impact visuals for broadcast, print, and social media — with strong typography, clear hierarchy, and motion that supports the story.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.72),
                    height: 1.5,
                  ),
                ),
              ).animate().fadeIn(duration: 520.ms, delay: 220.ms).slideY(begin: 0.12, end: 0),
              const SizedBox(height: 18),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: () => context.go('/projects'),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: const Text('View Projects'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/contact'),
                    icon: const Icon(Icons.mail_outline_rounded),
                    label: const Text('Contact Me'),
                  ),
                ],
              ).animate().fadeIn(duration: 520.ms, delay: 320.ms).slideY(begin: 0.12, end: 0),

              const SizedBox(height: 28),

              // Feature cards
              LayoutBuilder(
                builder: (context, c) {
                  final cols = isCompact ? 1 : 3;
                  final gap = 14.0;
                  final totalGap = gap * (cols - 1);
                  final cardW = (c.maxWidth - totalGap) / cols;

                  final cards = <Widget>[
                    _FeatureCard(
                      title: 'Brand Consistency',
                      desc: 'Design systems + templates that scale fast and stay clean.',
                      icon: Icons.layers_outlined,
                    ),
                    _FeatureCard(
                      title: 'Cinematic Motion',
                      desc: 'Motion that leads the eye and supports the message.',
                      icon: Icons.movie_filter_outlined,
                    ),
                    _FeatureCard(
                      title: 'Production Ready',
                      desc: 'Print specs, exports, compression, and delivery discipline.',
                      icon: Icons.verified_outlined,
                    ),
                  ];

                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final card in cards)
                        SizedBox(width: cardW, child: card),
                    ],
                  );
                },
              ).animate().fadeIn(duration: 600.ms, delay: 420.ms).slideY(begin: 0.12, end: 0),

              const SizedBox(height: 34),

              _Callout(
                title: 'Want a quick portfolio view?',
                desc: 'Open Projects to see curated work buckets. You can replace placeholders with your Behance case studies anytime.',
                primaryLabel: 'Go to Projects',
                onPrimary: () => context.go('/projects'),
              ).animate().fadeIn(duration: 650.ms, delay: 520.ms).slideY(begin: 0.12, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.72)),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.78),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  const _FeatureCard({required this.title, required this.desc, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HoverCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                ),
              ),
              child: Icon(icon, color: theme.colorScheme.onPrimary),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.72),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  final String title;
  final String desc;
  final String primaryLabel;
  final VoidCallback onPrimary;
  const _Callout({
    required this.title,
    required this.desc,
    required this.primaryLabel,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HoverCard(
      onTap: onPrimary,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.72),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            FilledButton.icon(
              onPressed: onPrimary,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(primaryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
