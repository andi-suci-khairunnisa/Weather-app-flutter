import 'package:cuaca_hari_ini/models/daily_forecast.dart';
import 'package:cuaca_hari_ini/ui/widgets/formatters.dart';
import 'package:cuaca_hari_ini/ui/widgets/weather_condition.dart';
import 'package:flutter/material.dart';

/// Daftar prakiraan harian (hingga 7 hari).
class DailyForecastList extends StatelessWidget {
  const DailyForecastList({super.key, required this.items});

  final List<DailyForecast> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          '7 Hari ke Depan',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                _DailyRow(
                  label: i == 0 ? 'Hari ini' : dayName(items[i].date),
                  item: items[i],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyRow extends StatelessWidget {
  const _DailyRow({required this.label, required this.item});

  final String label;
  final DailyForecast item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final condition = WeatherCondition.fromCode(item.weatherCode);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        spacing: 12,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Icon(condition.icon, size: 22, color: condition.color),
          Expanded(
            child: Text(
              condition.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            '${item.minTemperature.round()}°',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          Text(
            '${item.maxTemperature.round()}°',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}