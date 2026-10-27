import 'package:cuaca_hari_ini/models/json_utils.dart';

/// Prakiraan untuk satu jam.
class HourlyForecast {
  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.isDay,
  });

  /// Menerima satu entri: {time, temperature_2m, weather_code, is_day}.
  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: requireDateTime(json, 'time'),
      temperature: requireDouble(json, 'temperature_2m'),
      weatherCode: requireInt(json, 'weather_code'),
      isDay: (optionalDouble(json, 'is_day') ?? 1) >= 1,
    );
  }

  final DateTime time;
  final double temperature;
  final int weatherCode;
  final bool isDay;
}