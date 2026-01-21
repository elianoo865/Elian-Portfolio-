import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_shell.dart';
import 'pages/contact_page.dart';
import 'pages/experience_page.dart';
import 'pages/home_page.dart';
import 'pages/projects_page.dart';
import 'widgets/animated_gradient_background.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF00FFFF); // teal-blue

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ).copyWith(
        surface: const Color(0xFF0C1012),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AnimatedGradientBackground(
          child: AppShell(location: state.uri.toString(), child: child),
        );
      },
      routes: [
        _page('/', const HomePage()),
        _page('/experience', const ExperiencePage()),
        _page('/projects', const ProjectsPage()),
        _page('/contact', const ContactPage()),
      ],
    ),
  ],
);

GoRoute _page(String path, Widget child) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
        },
        child: child,
      );
    },
  );
}
