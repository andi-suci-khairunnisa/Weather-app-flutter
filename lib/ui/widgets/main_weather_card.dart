import 'package:cuaca_hari_ini/ui/widgets/formatters.dart';
import 'package:cuaca_hari_ini/ui/widgets/weather_condition.dart';
import 'package:flutter/material.dart';

/// Kartu utama: kota, jam pembaruan, suhu besar, ikon dan label cuaca.
class MainWeatherCard extends StatelessWidget {
  const MainWeatherCard({
    super.key,
    required this.cityName,
    required this.updatedAt,
    required this.temperature,
    required this.condition,
  });

  final String cityName;
  final DateTime updatedAt;
  final double temperature;
  final WeatherCondition condition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.surfaceContainerHigh,
            scheme.primary.withValues(alpha: 0.35),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
              Expanded(
                child: Text(
                  cityName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                'Diperbarui ${formatClock(updatedAt)}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Row(
            spacing: 16,
            children: [
              Text(
                '${temperature.round()}°',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  height: 1,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Icon(condition.icon, size: 36, color: condition.color),
                    Text(
                      condition.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}