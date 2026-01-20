import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        final a = Alignment(math.cos(t * math.pi * 2), math.sin(t * math.pi * 2));
        final b = Alignment(-a.x, -a.y);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: a,
              end: b,
              colors: [
                scheme.primary.withOpacity(0.22),
                scheme.secondary.withOpacity(0.16),
                scheme.tertiary.withOpacity(0.12),
                scheme.surface,
              ],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
