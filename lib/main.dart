import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const JelajahKiSulselApp());
}

class JelajahKiSulselApp extends StatelessWidget {
  const JelajahKiSulselApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema berdasarkan logo Kemenkumham (navy blue + yellow).
    const navyBlue = Color(0xFF1E1E5C);
    const yellow = Color(0xFFFFEB3B);

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: navyBlue,
        brightness: Brightness.light,
      ).copyWith(
        primary: navyBlue,
        secondary: yellow,
        tertiary: const Color(0xFF0EA5E9), // optional accent
      ),
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: base.colorScheme.onSurface);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jelajah KI Sulsel',
      builder: (context, child) {
        // Global background for all pages.
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/bg/bg.png',
              fit: BoxFit.cover,
            ),
            // Optional overlay to improve contrast.
            Container(color: Colors.white.withValues(alpha: 0.02)),
            if (child != null) child,
          ],
        );
      },
      theme: base.copyWith(
        textTheme: textTheme,
        // Make Scaffold background transparent so the global background is visible.
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: base.colorScheme.surface,
          foregroundColor: base.colorScheme.onSurface,
          centerTitle: false,
          titleTextStyle: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          color: base.colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
