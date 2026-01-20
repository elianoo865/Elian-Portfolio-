import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const HoverCard({super.key, required this.child, this.onTap});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        scale: _hover ? 1.015 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(_hover ? 0.92 : 0.86),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(_hover ? 0.10 : 0.06),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: _hover ? 28 : 16,
                spreadRadius: 0,
                offset: const Offset(0, 10),
                color: Colors.black.withOpacity(_hover ? 0.18 : 0.12),
              )
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.onTap,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
