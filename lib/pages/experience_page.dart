import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/experience_data.dart';
import '../widgets/hover_card.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 40),
        child: ResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Experience',
                subtitle: 'A timeline of roles, responsibilities, and the kind of value I like delivering.',
              ),
              const SizedBox(height: 18),

              Column(
                children: [
                  for (int i = 0; i < experiences.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _ExperienceCard(index: i),
                    ),
                ],
              ).animate().fadeIn(duration: 520.ms).slideY(begin: 0.08, end: 0),

              const SizedBox(height: 22),
              Text(
                'Tools I use daily',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _ToolChip('Adobe Photoshop'),
                  _ToolChip('Adobe Illustrator'),
                  _ToolChip('Adobe InDesign'),
                  _ToolChip('Premiere Pro'),
                  _ToolChip('After Effects'),
                  _ToolChip('Lightroom'),
                  _ToolChip('Figma (basic)'),
                ],
              ).animate().fadeIn(duration: 520.ms, delay: 160.ms).slideY(begin: 0.08, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final int index;
  const _ExperienceCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = experiences[index];

    return HoverCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: theme.colorScheme.primary.withOpacity(0.12),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.18)),
              ),
              child: Icon(Icons.work_outline, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        e.role,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      _MetaPill(e.period),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${e.company} • ${e.location}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.72),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...e.highlights.map(
                    (h) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(Icons.check_circle, size: 16, color: theme.colorScheme.tertiary),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              h,
                              style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 420.ms, delay: (index * 90).ms).slideY(begin: 0.08, end: 0);
  }
}

class _MetaPill extends StatelessWidget {
  final String text;
  const _MetaPill(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.72),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  final String text;
  const _ToolChip(this.text);

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
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.78),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
