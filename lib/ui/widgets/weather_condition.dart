import 'package:flutter/material.dart';

const Color _sunColor = Color(0xFFF5A25D);
const Color _nightColor = Color(0xFFB8C4FF);
const Color _cloudColor = Color(0xFFA9B8D6);
const Color _rainColor = Color(0xFF6FA8FF);
const Color _snowColor = Color(0xFFCFE8FF);
const Color _stormColor = Color(0xFFFFD166);
const Color _fogColor = Color(0xFF9AA8C0);

/// Pemetaan kode cuaca WMO (weather_code) ke label dan ikon.
class WeatherCondition {
  const WeatherCondition(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  static WeatherCondition fromCode(int code, {bool isDay = true}) {
    return switch (code) {
      0 => isDay
          ? const WeatherCondition('Cerah', Icons.wb_sunny_rounded, _sunColor)
          : const WeatherCondition(
              'Cerah',
              Icons.nightlight_round,
              _nightColor,
            ),
      1 => const WeatherCondition(
          'Cerah berawan',
          Icons.wb_cloudy_rounded,
          _cloudColor,
        ),
      2 => const WeatherCondition(
          'Berawan sebagian',
          Icons.wb_cloudy_rounded,
          _cloudColor,
        ),
      3 => const WeatherCondition('Mendung', Icons.cloud_rounded, _cloudColor),
      45 || 48 => const WeatherCondition(
          'Berkabut',
          Icons.blur_on_rounded,
          _fogColor,
        ),
      51 || 53 || 55 => const WeatherCondition(
          'Gerimis',
          Icons.grain_rounded,
          _sunColor,
        ),
      56 || 57 => const WeatherCondition(
          'Gerimis beku',
          Icons.grain_rounded,
          _snowColor,
        ),
      61 => const WeatherCondition(
          'Hujan ringan',
          Icons.water_drop_rounded,
          _rainColor,
        ),
      63 => const WeatherCondition(
          'Hujan sedang',
          Icons.water_drop_rounded,
          _rainColor,
        ),
      65 => const WeatherCondition(
          'Hujan lebat',
          Icons.umbrella_rounded,
          _rainColor,
        ),
      66 || 67 => const WeatherCondition(
          'Hujan beku',
          Icons.umbrella_rounded,
          _snowColor,
        ),
      71 || 73 || 75 => const WeatherCondition(
          'Salju',
          Icons.ac_unit_rounded,
          _snowColor,
        ),
      77 => const WeatherCondition(
          'Butiran salju',
          Icons.ac_unit_rounded,
          _snowColor,
        ),
      80 || 81 => const WeatherCondition(
          'Hujan sesaat',
          Icons.water_drop_rounded,
          _rainColor,
        ),
      82 => const WeatherCondition(
          'Hujan deras sesaat',
          Icons.umbrella_rounded,
          _rainColor,
        ),
      85 || 86 => const WeatherCondition(
          'Salju sesaat',
          Icons.ac_unit_rounded,
          _snowColor,
        ),
      95 => const WeatherCondition(
          'Badai petir',
          Icons.thunderstorm_rounded,
          _stormColor,
        ),
      96 || 99 => const WeatherCondition(
          'Badai petir disertai es',
          Icons.thunderstorm_rounded,
          _stormColor,
        ),
      _ => const WeatherCondition(
          'Tidak diketahui',
          Icons.help_outline_rounded,
          _fogColor,
        ),
    };
  }
}

/// Kategori kecepatan angin (km/j) untuk kartu info.
String windCategory(double speedKmh) {
  if (speedKmh < 5) return 'tenang';
  if (speedKmh < 12) return 'lemah';
  if (speedKmh < 30) return 'sedang';
  if (speedKmh < 50) return 'kencang';
  return 'sangat kencang';
}