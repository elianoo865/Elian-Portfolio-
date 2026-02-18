import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../state/portfolio_state.dart';
import '../widgets/hover_card.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = PortfolioStateScope.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 40),
        child: ResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Contact',
                subtitle: 'Fastest ways to reach me. (You can replace links anytime.)',
              ),
              const SizedBox(height: 18),

              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  SizedBox(
                    width: 520,
                    child: HoverCard(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Let’s build something clean',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'If you have a project, send a message with a short brief + deadline. I’ll reply with questions and a clear plan.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.72),
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 14),
                            FilledButton.icon(
                              onPressed: () => _open('mailto:${state.contactEmail}'),
                              icon: const Icon(Icons.send_rounded),
                              label: const Text('Email Me'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 520,
                    child: Column(
                      children: [
                        _ContactTile(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: state.contactEmail,
                          onCopy: () => _copy(context, state.contactEmail),
                          onOpen: () => _open('mailto:${state.contactEmail}'),
                        ),
                        const SizedBox(height: 14),
                        _ContactTile(
                          icon: Icons.phone_outlined,
                          title: 'Phone',
                          value: state.contactPhone,
                          onCopy: () => _copy(context, state.contactPhone),
                          onOpen: () => _open('tel:${state.contactPhone}'),
                        ),
                        const SizedBox(height: 14),
                        _ContactTile(
                          icon: Icons.work_outline,
                          title: 'LinkedIn',
                          value: state.contactLinkedin,
                          onCopy: () => _copy(context, state.contactLinkedin),
                          onOpen: () => _open(state.contactLinkedin),
                        ),
                        const SizedBox(height: 14),
                        _ContactTile(
                          icon: Icons.brush_outlined,
                          title: 'Behance',
                          value: state.contactBehance,
                          onCopy: () => _copy(context, state.contactBehance),
                          onOpen: () => _open(state.contactBehance),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 520.ms).slideY(begin: 0.08, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onCopy;
  final VoidCallback onOpen;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onCopy,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HoverCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: theme.colorScheme.tertiary.withOpacity(0.12),
                border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.18)),
              ),
              child: Icon(icon, color: theme.colorScheme.tertiary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.72),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              tooltip: 'Copy',
              onPressed: onCopy,
              icon: const Icon(Icons.copy_rounded),
            ),
            IconButton(
              tooltip: 'Open',
              onPressed: onOpen,
              icon: const Icon(Icons.north_east_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
