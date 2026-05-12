import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../data/weather_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MoroccoCity _city;
  CityWeatherSnapshot? _snapshot;

  @override
  void initState() {
    super.initState();
    _city = moroccoCities.firstWhere((item) => item.name == homeCityName);
    _snapshot = fallbackWeatherSnapshots[_city.name];
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    for (final city in moroccoCities) {
      try {
        final snapshot = await WeatherRepository.loadWeatherForCity(
          city,
          fetchIfStale: true,
        );
        if (!mounted) return;
        if (city.name == _city.name) {
          setState(() {
            _snapshot = snapshot;
          });
        }
      } catch (_) {
        // Keep last available snapshot on screen.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;
    final forecastRows = _forecastRows(snapshot);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final heroHeight = (constraints.maxHeight * 0.5).clamp(360.0, 530.0);

            return Column(
              children: [
                const _HomeHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroSection(
                          city: _city,
                          snapshot: snapshot,
                          height: heroHeight,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _InsightCard(
                                      title: 'Wind',
                                      value: snapshot == null
                                          ? _city.wind.value
                                          : '${(snapshot.current.windSpeedMs * 3.6).round()} km/h',
                                      detail: snapshot == null ? _city.wind.detail : 'NW Gusty',
                                      icon: Icons.air,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _InsightCard(
                                      title: 'Humidity',
                                      value: snapshot == null
                                          ? _city.humidity.value
                                          : '${snapshot.current.humidity}%',
                                      detail: snapshot == null
                                          ? _city.humidity.detail
                                          : 'Optimal',
                                      icon: Icons.water_drop_outlined,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: _glassCardDecoration(borderTop: true),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '5-Day Outlook',
                                          style: AppTextStyles.headingMedium.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_month,
                                          color: AppColors.secondary,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    ...forecastRows.asMap().entries.map(
                                          (entry) => _ForecastRow(
                                            label: entry.value.label,
                                            icon: entry.value.icon,
                                            high: entry.value.high,
                                            low: entry.value.low,
                                            isActive: entry.key == 0,
                                            isLast: entry.key == forecastRows.length - 1,
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<_ForecastItem> _forecastRows(CityWeatherSnapshot? snapshot) {
    final fallbackRows = _fallbackForecastRows(_city);
    final days = snapshot?.nextFiveDays;
    if (days == null || days.isEmpty) {
      return fallbackRows;
    }

    final liveRows = days.take(5).toList().asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return _ForecastItem(
        label: index == 0 ? 'Today' : _shortDayLabel(item.date),
        icon: _weatherIcon(item.weatherMain, item.weatherDescription),
        high: item.high.round(),
        low: item.low.round(),
      );
    }).toList();

    if (liveRows.length == 5) return liveRows;

    return [
      ...liveRows,
      ...fallbackRows.skip(liveRows.length).take(5 - liveRows.length),
    ];
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(color: AppColors.secondary.withValues(alpha: 0.18)),
        ),
      ),
      child: Row(
        children: [
          Text(
            'MOROCCO TRAVEL',
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final MoroccoCity city;
  final CityWeatherSnapshot? snapshot;
  final double height;

  const _HeroSection({
    required this.city,
    required this.snapshot,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final current = snapshot?.current;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(city.detailImageUrl, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.05),
                  AppColors.background.withValues(alpha: 0.35),
                  AppColors.background,
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.18),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.85, -0.9),
                  radius: 1.2,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text(
                      'CURRENT LOCATION',
                      style: AppTextStyles.labelCaps.copyWith(
                        color: AppColors.secondary,
                        letterSpacing: 2.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(city.name, style: AppTextStyles.display),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${current?.displayTemp ?? city.currentTemp}°C',
                      style: AppTextStyles.dataDisplay.copyWith(
                        color: AppColors.primary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current?.conditionLabel ?? city.condition,
                            style: AppTextStyles.headingMedium.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            'RealFeel ${current?.feelsLike.round() ?? city.realFeel}°',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String detail;
  final IconData icon;

  const _InsightCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.all(16),
      decoration: _glassCardDecoration(),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              icon,
              size: 48,
              color: AppColors.textMuted.withValues(alpha: 0.16),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTextStyles.labelCaps.copyWith(
                  color: AppColors.outlineVariant,
                ),
              ),
              const Spacer(),
              Text(value, style: AppTextStyles.headingMedium),
              const SizedBox(height: 2),
              Text(
                detail,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int high;
  final int low;
  final bool isActive;
  final bool isLast;

  const _ForecastRow({
    required this.label,
    required this.icon,
    required this.high,
    required this.low,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        icon == Icons.cloud ? AppColors.textSecondary : AppColors.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
              ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Icon(icon, color: iconColor, size: 22),
            ),
          ),
          SizedBox(
            width: 96,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$high°',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$low°',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _glassCardDecoration({bool borderTop = false}) {
  return BoxDecoration(
    color: AppColors.surfaceHigh.withValues(alpha: 0.6),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.14),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        borderTop
            ? AppColors.secondary.withValues(alpha: 0.08)
            : AppColors.surfaceHigh.withValues(alpha: 0.75),
        AppColors.surface.withValues(alpha: 0.9),
      ],
    ),
  );
}

List<_ForecastItem> _fallbackForecastRows(MoroccoCity city) {
  final rows = city.dailyForecast.take(5).toList();
  return <_ForecastItem>[
    rows.isNotEmpty
        ? _ForecastItem(label: 'Today', icon: rows[0].icon, high: rows[0].high, low: rows[0].low)
        : const _ForecastItem(label: 'Today', icon: Icons.wb_sunny, high: 24, low: 16),
    rows.length > 1
        ? _ForecastItem(
            label: 'Mon',
            icon: rows[1].icon,
            high: rows[1].high,
            low: rows[1].low,
          )
        : const _ForecastItem(label: 'Mon', icon: Icons.cloud_queue, high: 22, low: 15),
    rows.length > 2
        ? _ForecastItem(
            label: 'Tue',
            icon: rows[2].icon,
            high: rows[2].high,
            low: rows[2].low,
          )
        : const _ForecastItem(label: 'Tue', icon: Icons.wb_sunny, high: 26, low: 17),
    rows.length > 3
        ? _ForecastItem(
            label: 'Wed',
            icon: rows[3].icon,
            high: rows[3].high,
            low: rows[3].low,
          )
        : const _ForecastItem(label: 'Wed', icon: Icons.cloud, high: 21, low: 14),
    rows.length > 4
        ? _ForecastItem(
            label: 'Thu',
            icon: rows[4].icon,
            high: rows[4].high,
            low: rows[4].low,
          )
        : const _ForecastItem(label: 'Thu', icon: Icons.wb_sunny, high: 25, low: 16),
  ];
}

String _shortDayLabel(DateTime dateTime) {
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return labels[dateTime.weekday - 1];
}

IconData _weatherIcon(String weatherMain, String weatherDescription) {
  final description = weatherDescription.toLowerCase();
  if (weatherMain == 'Clear') return Icons.wb_sunny;
  if (weatherMain == 'Rain' || description.contains('rain')) return Icons.umbrella;
  if (description.contains('overcast')) return Icons.cloud;
  if (weatherMain == 'Wind' || description.contains('wind')) return Icons.air;
  return Icons.cloud_queue;
}

class _ForecastItem {
  final String label;
  final IconData icon;
  final int high;
  final int low;

  const _ForecastItem({
    required this.label,
    required this.icon,
    required this.high,
    required this.low,
  });
}
