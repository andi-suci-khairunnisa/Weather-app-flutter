import 'package:cuaca_hari_ini/ui/screens/weather_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuaca Hari Ini',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const WeatherScreen(),
    );
  }
}

/// Tema gelap Material 3 dengan palet biru-navy yang konsisten.
ThemeData _buildTheme() {
  final base = ColorScheme.fromSeed(
    seedColor: const Color(0xFF5B8DEF),
    brightness: Brightness.dark,
  );
  final scheme = base.copyWith(
    primary: const Color(0xFF5B8DEF),
    onPrimary: const Color(0xFF0B1220),
    error: const Color(0xFFFF8A80),
    surface: const Color(0xFF0B1220),
    surfaceContainer: const Color(0xFF141C30),
    surfaceContainerHigh: const Color(0xFF1C2A47),
    onSurfaceVariant: const Color(0xFF9AA8C0),
    outlineVariant: const Color(0xFF26324D),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.surfaceContainerHigh,
      contentTextStyle: TextStyle(color: scheme.onSurface),
    ),
  );
}