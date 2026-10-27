import 'package:cuaca_hari_ini/models/hourly_forecast.dart';
import 'package:cuaca_hari_ini/ui/widgets/formatters.dart';
import 'package:cuaca_hari_ini/ui/widgets/weather_condition.dart';
import 'package:flutter/material.dart';

/// Deretan horizontal prakiraan per jam.
class HourlyForecastStrip extends StatelessWidget {
  const HourlyForecastStrip({super.key, required this.items});

  final List<HourlyForecast> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          'Per Jam',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            children: [
              for (var i = 0; i < items.length; i++)
                _HourlyTile(
                  label: i == 0 ? 'Sekarang' : formatClock(items[i].time),
                  item: items[i],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HourlyTile extends StatelessWidget {
  const _HourlyTile({required this.label, required this.item});

  final String label;
  final HourlyForecast item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final condition = WeatherCondition.fromCode(
      item.weatherCode,
      isDay: item.isDay,
    );

    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        spacing: 10,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          Icon(condition.icon, size: 26, color: condition.color),
          Text(
            '${item.temperature.round()}°',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}