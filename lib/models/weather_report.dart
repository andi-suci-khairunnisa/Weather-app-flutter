import 'package:cuaca_hari_ini/models/current_weather.dart';
import 'package:cuaca_hari_ini/models/daily_forecast.dart';
import 'package:cuaca_hari_ini/models/hourly_forecast.dart';
import 'package:cuaca_hari_ini/models/json_utils.dart';

/// Seluruh data cuaca dari satu respons API.
class WeatherReport {
  const WeatherReport({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherReport.fromJson(Map<String, dynamic> json) {
    final current = CurrentWeather.fromJson(
      requireMap(json['current'], 'current'),
    );

    return WeatherReport(
      current: current,
      hourly: _parseHourly(requireMap(json['hourly'], 'hourly'), current.time),
      daily: _parseDaily(requireMap(json['daily'], 'daily')),
    );
  }

  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
}

/// API mengirim array paralel; di sini diubah menjadi daftar objek.
/// Hanya 24 jam ke depan mulai dari jam saat ini yang disimpan.
List<HourlyForecast> _parseHourly(
  Map<String, dynamic> json,
  DateTime now,
) {
  final times = requireList(json['time'], 'hourly.time');
  final temps = requireList(json['temperature_2m'], 'hourly.temperature_2m');
  final codes = requireList(json['weather_code'], 'hourly.weather_code');
  final isDays = json['is_day'];

  if (temps.length != times.length || codes.length != times.length) {
    throw const FormatException('Data prakiraan per jam tidak lengkap.');
  }

  final startOfHour = DateTime(now.year, now.month, now.day, now.hour);
  final result = <HourlyForecast>[];

  for (var i = 0; i < times.length; i++) {
    // Lewati entri yang nilainya kosong agar satu data null tidak merusak semuanya.
    if (temps[i] == null || codes[i] == null) continue;

    final item = HourlyForecast.fromJson(<String, dynamic>{
      'time': times[i],
      'temperature_2m': temps[i],
      'weather_code': codes[i],
      'is_day': isDays is List<dynamic> && i < isDays.length ? isDays[i] : null,
    });
    if (item.time.isBefore(startOfHour)) continue;

    result.add(item);
    if (result.length >= 24) break;
  }

  return List.unmodifiable(result);
}

List<DailyForecast> _parseDaily(Map<String, dynamic> json) {
  final dates = requireList(json['time'], 'daily.time');
  final codes = requireList(json['weather_code'], 'daily.weather_code');
  final maxes = requireList(
    json['temperature_2m_max'],
    'daily.temperature_2m_max',
  );
  final mins = requireList(
    json['temperature_2m_min'],
    'daily.temperature_2m_min',
  );

  if (codes.length != dates.length ||
      maxes.length != dates.length ||
      mins.length != dates.length) {
    throw const FormatException('Data prakiraan harian tidak lengkap.');
  }

  final result = <DailyForecast>[];
  for (var i = 0; i < dates.length; i++) {
    if (codes[i] == null || maxes[i] == null || mins[i] == null) continue;

    result.add(
      DailyForecast.fromJson(<String, dynamic>{
        'time': dates[i],
        'weather_code': codes[i],
        'temperature_2m_max': maxes[i],
        'temperature_2m_min': mins[i],
      }),
    );
  }

  return List.unmodifiable(result);
}