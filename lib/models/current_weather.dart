import 'package:cuaca_hari_ini/models/json_utils.dart';

/// Kondisi cuaca saat ini (blok `current` dari Open-Meteo).
class CurrentWeather {
  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
    this.apparentTemperature,
    this.pressure,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: requireDateTime(json, 'time'),
      temperature: requireDouble(json, 'temperature_2m'),
      humidity: requireInt(json, 'relative_humidity_2m'),
      windSpeed: requireDouble(json, 'wind_speed_10m'),
      weatherCode: requireInt(json, 'weather_code'),
      // Field opsional: boleh null, UI hanya menampilkannya bila ada.
      apparentTemperature: optionalDouble(json, 'apparent_temperature'),
      pressure: optionalDouble(json, 'pressure_msl'),
      isDay: (optionalDouble(json, 'is_day') ?? 1) >= 1,
    );
  }

  final DateTime time;
  final double temperature;
  final double? apparentTemperature;
  final int humidity;
  final double windSpeed;
  final double? pressure;
  final int weatherCode;
  final bool isDay;
}