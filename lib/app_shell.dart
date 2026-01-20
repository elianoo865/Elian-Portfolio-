import 'dart:ui';

import 'package:flutter/material.dart';

import 'widgets/bottom_nav.dart';
import 'widgets/top_nav.dart';

class AppShell extends StatelessWidget {
  final String location;
  final Widget child;

  const AppShell({super.key, required this.location, required this.child});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isDesktop = w >= 900;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? PreferredSize(
              preferredSize: const Size.fromHeight(74),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: TopNav(location: location),
                ),
              ),
            )
          : null,
      body: SafeArea(
        top: isDesktop ? false : true,
        child: child,
      ),
      bottomNavigationBar: isDesktop ? null : BottomNav(location: location),
    );
  }
}
