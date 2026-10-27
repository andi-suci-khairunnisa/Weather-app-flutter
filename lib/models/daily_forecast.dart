import 'package:cuaca_hari_ini/models/json_utils.dart';

/// Prakiraan untuk satu hari.
class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
  });

  /// Menerima satu entri: {time, weather_code, temperature_2m_max, temperature_2m_min}.
  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: requireDateTime(json, 'time'),
      weatherCode: requireInt(json, 'weather_code'),
      maxTemperature: requireDouble(json, 'temperature_2m_max'),
      minTemperature: requireDouble(json, 'temperature_2m_min'),
    );
  }

  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;
}