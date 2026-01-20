import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/project_data.dart';
import '../models/project.dart';
import '../widgets/hover_card.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  String _filter = 'All';

  List<String> get _filters {
    final set = <String>{'All'};
    for (final p in projects) {
      set.add(p.category);
    }
    return set.toList();
  }

  List<Project> get _visible {
    if (_filter == 'All') return projects;
    return projects.where((p) => p.category == _filter).toList();
  }

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
                title: 'Projects',
                subtitle: 'Curated buckets you can expand into full case studies (Behance, PDFs, or deep dives).',
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final f in _filters)
                    ChoiceChip(
                      selected: _filter == f,
                      label: Text(f),
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                ],
              ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.08, end: 0),

              const SizedBox(height: 18),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(anim),
                    child: child,
                  ),
                ),
                child: _Grid(
                  key: ValueKey(_filter),
                  items: _visible,
                ),
              ),

              const SizedBox(height: 22),
              Text(
                'Tip: Replace placeholders with real projects',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Open lib/data/project_data.dart and add your Behance links. The UI auto-updates and keeps the layout consistent.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.72),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final List<Project> items;
  const _Grid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w >= 1100 ? 3 : (w >= 800 ? 2 : 1);

    return LayoutBuilder(
      builder: (context, c) {
        final gap = 14.0;
        final totalGap = gap * (cols - 1);
        final cardW = (c.maxWidth - totalGap) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (int i = 0; i < items.length; i++)
              SizedBox(
                width: cardW,
                child: _ProjectCard(p: items[i], index: i),
              ),
          ],
        );
      },
    ).animate().fadeIn(duration: 520.ms, delay: 120.ms).slideY(begin: 0.08, end: 0);
  }
}

class _ProjectCard extends StatelessWidget {
  final Project p;
  final int index;
  const _ProjectCard({required this.p, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HoverCard(
      onTap: () {
        // Add url_launcher here if you set links.
      },
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.18)),
                  ),
                  child: Text(
                    p.category,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.north_east_rounded, color: theme.colorScheme.onSurface.withOpacity(0.35)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              p.title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              p.subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.72),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in p.tags)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: theme.colorScheme.onSurface.withOpacity(0.05),
                      border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
                    ),
                    child: Text(
                      t,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.76),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 420.ms, delay: (index * 80).ms).slideY(begin: 0.08, end: 0);
  }
}
