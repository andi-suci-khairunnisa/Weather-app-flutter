import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cuaca_hari_ini/models/weather_report.dart';
import 'package:cuaca_hari_ini/services/api_exception.dart';
import 'package:http/http.dart' as http;

/// Satu-satunya tempat yang memanggil jaringan (http).
class WeatherService {
  WeatherService({
    this.cityName = 'Fakultas Teknik, Universitas Hasanuddin',
    this.latitude = -5.230025,
    this.longitude = 119.502063,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Label lokasi untuk tampilan. Open-Meteo tidak mengirim nama kota,
  /// jadi nama ini ikut sebagai konfigurasi bersama koordinatnya.
  final String cityName;
  final double latitude;
  final double longitude;

  final http.Client _client;

  static const Duration _timeout = Duration(seconds: 10);

  Future<WeatherReport> fetchWeather() async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current': 'temperature_2m,apparent_temperature,relative_humidity_2m,'
          'is_day,pressure_msl,wind_speed_10m,weather_code',
      'hourly': 'temperature_2m,weather_code,is_day',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
      'wind_speed_unit': 'kmh',
      'forecast_days': '7',
      'timezone': 'auto',
    });

    try {
      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException(
          'Server cuaca merespons dengan status ${response.statusCode}. '
          'Coba lagi beberapa saat lagi.',
        );
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Respons bukan objek JSON.');
      }
      return WeatherReport.fromJson(decoded);
    } on ApiException {
      rethrow;
    } on SocketException {
      throw const ApiException(
        'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
      );
    } on TimeoutException {
      throw const ApiException(
        'Permintaan melebihi batas waktu 10 detik. Koneksi mungkin lambat.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Tidak dapat terhubung ke server cuaca. Periksa koneksi internet Anda.',
      );
    } on FormatException catch (e) {
      throw ApiException('Format data dari server tidak valid: ${e.message}');
    } on Exception {
      throw const ApiException('Terjadi kesalahan tak terduga. Coba lagi.');
    }
  }

  /// Menutup koneksi saat service tidak dipakai lagi.
  void dispose() => _client.close();
}