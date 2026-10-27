import 'package:cuaca_hari_ini/models/weather_report.dart';
import 'package:cuaca_hari_ini/services/api_exception.dart';
import 'package:cuaca_hari_ini/services/weather_service.dart';
import 'package:cuaca_hari_ini/ui/widgets/daily_forecast_list.dart';
import 'package:cuaca_hari_ini/ui/widgets/error_view.dart';
import 'package:cuaca_hari_ini/ui/widgets/hourly_forecast_strip.dart';
import 'package:cuaca_hari_ini/ui/widgets/info_banner.dart';
import 'package:cuaca_hari_ini/ui/widgets/loading_view.dart';
import 'package:cuaca_hari_ini/ui/widgets/main_weather_card.dart';
import 'package:cuaca_hari_ini/ui/widgets/refresh_button.dart';
import 'package:cuaca_hari_ini/ui/widgets/weather_condition.dart';
import 'package:cuaca_hari_ini/ui/widgets/weather_info_card.dart';
import 'package:flutter/material.dart';

/// Tiga kondisi layar: loading, sukses, error.
sealed class _ViewState {
  const _ViewState();
}

final class _Loading extends _ViewState {
  const _Loading();
}

final class _Success extends _ViewState {
  const _Success(this.report);

  final WeatherReport report;
}

final class _Error extends _ViewState {
  const _Error(this.message);

  final String message;
}

/// Halaman penuh sekaligus satu-satunya pengatur state.
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _service = WeatherService();

  _ViewState _state = const _Loading();

  // True saat memperbarui data yang sudah tampil (tombol / tarik ke bawah).
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  /// Muat dari awal: kembali ke state loading, lalu sukses atau error.
  Future<void> _load() async {
    if (_state is! _Loading) {
      setState(() => _state = const _Loading());
    }

    try {
      final report = await _service.fetchWeather();
      if (!mounted) return;
      setState(() => _state = _Success(report));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _state = _Error(e.message));
    }
  }

  /// Perbarui data tanpa menghilangkan tampilan lama.
  /// Jika gagal, data lama dipertahankan dan pesan muncul di SnackBar.
  Future<void> _refresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    try {
      final report = await _service.fetchWeather();
      if (!mounted) return;
      setState(() {
        _state = _Success(report);
        _isRefreshing = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuaca Hari Ini')),
      body: SafeArea(
        top: false,
        child: switch (_state) {
          _Loading() => const LoadingView(),
          _Error(:final message) => ErrorView(
              message: message,
              onRetry: _load,
            ),
          _Success(:final report) => _buildContent(report),
        },
      ),
    );
  }

  Widget _buildContent(WeatherReport report) {
    final current = report.current;
    final condition = WeatherCondition.fromCode(
      current.weatherCode,
      isDay: current.isDay,
    );
    final apparent = current.apparentTemperature;
    final pressure = current.pressure;

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                MainWeatherCard(
                  cityName: _service.cityName,
                  updatedAt: current.time,
                  temperature: current.temperature,
                  condition: condition,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: WeatherInfoCard(
                        icon: Icons.water_drop_outlined,
                        label: 'Kelembapan',
                        value: '${current.humidity}',
                        unit: '%',
                      ),
                    ),
                    Expanded(
                      child: WeatherInfoCard(
                        icon: Icons.air_rounded,
                        label: 'Angin',
                        value: '${current.windSpeed.round()}',
                        unit: 'km/j',
                      ),
                    ),
                  ],
                ),
                if (apparent != null || pressure != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      if (apparent != null)
                        Expanded(
                          child: WeatherInfoCard(
                            icon: Icons.thermostat_rounded,
                            label: 'Terasa seperti',
                            value: '${apparent.round()}°',
                            unit: 'C',
                          ),
                        ),
                      if (pressure != null)
                        Expanded(
                          child: WeatherInfoCard(
                            icon: Icons.speed_rounded,
                            label: 'Tekanan',
                            value: '${pressure.round()}',
                            unit: 'hPa',
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                InfoBanner(
                  message:
                      'Kondisi angin ${windCategory(current.windSpeed)}. '
                      'Data bersumber dari Open-Meteo.',
                ),
                if (report.hourly.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  HourlyForecastStrip(items: report.hourly),
                ],
                if (report.daily.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  DailyForecastList(items: report.daily),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: RefreshButton(isLoading: _isRefreshing, onPressed: _refresh),
        ),
      ],
    );
  }
}