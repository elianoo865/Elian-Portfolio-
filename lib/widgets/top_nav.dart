import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopNav extends StatelessWidget implements PreferredSizeWidget {
  final String location;
  const TopNav({super.key, required this.location});

  @override
  Size get preferredSize => const Size.fromHeight(74);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = <_NavItem>[
      const _NavItem(label: 'Home', route: '/'),
      const _NavItem(label: 'Experience', route: '/experience'),
      const _NavItem(label: 'Projects', route: '/projects'),
      const _NavItem(label: 'Contact', route: '/contact'),
    ];

    return AppBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.surface.withOpacity(0.72),
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13,
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
              ),
            ),
                 child: Image.asset(
                  'assets/icons/elian.png',
                  width: 18,
                  height: 18,
                ),

          ),
          const SizedBox(width: 12),
          Text(
            'Elian Al‑Kadar',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          ...items.map((e) {
            final active = _isActive(location, e.route);
            return _NavButton(
              label: e.label,
              active: active,
              onTap: () => context.go(e.route),
            );
          }),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  static bool _isActive(String location, String route) {
    if (route == '/') return location == '/';
    return location.startsWith(route);
  }
}

class _NavItem {
  final String label;
  final String route;
  const _NavItem({required this.label, required this.route});
}

class _NavButton extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavButton({required this.label, required this.active, required this.onTap});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = widget.active
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withOpacity(_hover ? 0.84 : 0.66);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: widget.active
                  ? theme.colorScheme.onSurface.withOpacity(0.06)
                  : (_hover ? theme.colorScheme.onSurface.withOpacity(0.04) : Colors.transparent),
              border: Border.all(
                color: widget.active
                    ? theme.colorScheme.primary.withOpacity(0.32)
                    : Colors.transparent,
              ),
            ),
            child: Text(
              widget.label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: fg,
                fontWeight: widget.active ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
