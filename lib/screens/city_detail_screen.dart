import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../data/weather_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_header.dart';

class CityDetailScreen extends StatefulWidget {
  final MoroccoCity city;
  final bool embedded;
  final VoidCallback? onBack;

  const CityDetailScreen({
    super.key,
    required this.city,
    this.embedded = false,
    this.onBack,
  });

  @override
  State<CityDetailScreen> createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  CityWeatherSnapshot? _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = fallbackWeatherSnapshots[widget.city.name];
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final snapshot = await WeatherRepository.loadWeatherForCity(
        widget.city,
        fetchIfStale: true,
      );
      if (!mounted) return;
      setState(() {
        _snapshot = snapshot;
      });
    } catch (_) {
      // Keep the fallback/cached snapshot on screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: 'MOROCCO TRAVEL',
        showBackButton: widget.embedded,
        onBackTap: widget.onBack,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroSection(city: widget.city, snapshot: snapshot),
            const SizedBox(height: 32),
            Text(
              '24-Hour Forecast',
              style: AppTextStyles.labelCaps.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _detailCardDecoration(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final point in snapshot?.hourlyWindow ?? const <WeatherPoint>[]) ...[
                      _HourlyPoint(point: point),
                      const SizedBox(width: 12),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
              children: [
                _MetricTile(
                  metric: _buildHumidityMetric(snapshot, widget.city),
                ),
                _MetricTile(
                  metric: _buildWindMetric(snapshot, widget.city),
                ),
                _MetricTile(
                  metric: _buildCloudMetric(snapshot, widget.city),
                ),
                _MetricTile(
                  metric: _buildVisibilityMetric(widget.city),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _detailCardDecoration(borderAccent: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_twilight, color: AppColors.textMuted, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'SUNRISE & SUNSET',
                        style: AppTextStyles.labelCaps.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 90,
                    width: double.infinity,
                    child: CustomPaint(painter: _SunArcPainter()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SunTime(
                        label: 'SUNRISE',
                        value: snapshot?.sunrise ?? widget.city.sunrise,
                        alignEnd: false,
                      ),
                      _SunTime(
                        label: 'SUNSET',
                        value: snapshot?.sunset ?? widget.city.sunset,
                        alignEnd: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final MoroccoCity city;
  final CityWeatherSnapshot? snapshot;

  const _HeroSection({
    required this.city,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final current = snapshot?.current;

    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      decoration: _detailCardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.network(city.detailImageUrl, fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  city.name,
                  style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${current?.conditionLabel ?? city.condition} | ${_formatLongDate(current?.dateTime)}',
                  style: AppTextStyles.labelCaps.copyWith(color: AppColors.secondary),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${current?.displayTemp ?? city.currentTemp}°',
                    style: AppTextStyles.dataDisplay,
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

class _HourlyPoint extends StatelessWidget {
  final WeatherPoint point;

  const _HourlyPoint({required this.point});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: point.isCurrent
            ? AppColors.primaryContainer.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: point.isCurrent
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        children: [
          Text(
            _formatHour(point.dateTime),
            style: AppTextStyles.labelCaps.copyWith(
              color: point.isCurrent ? AppColors.textPrimary : AppColors.textMuted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 10),
          Icon(
            _weatherIcon(point.weatherMain, point.weatherDescription),
            color: point.isCurrent ? AppColors.primary : AppColors.textSecondary,
            size: 22,
          ),
          const SizedBox(height: 10),
          Text(
            '${point.displayTemp}°',
            style: AppTextStyles.bodyLarge.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final WeatherMetric metric;

  const _MetricTile({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _detailCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(metric.icon, color: AppColors.textMuted, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  metric.title.toUpperCase(),
                  style: AppTextStyles.labelCaps.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              text: metric.value.split(' ').first,
              style: AppTextStyles.headingLarge.copyWith(fontSize: 28),
              children: metric.value.contains(' ')
                  ? [
                      TextSpan(
                        text: ' ${metric.value.split(' ').skip(1).join(' ')}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ]
                  : const [],
            ),
          ),
          const SizedBox(height: 6),
          if (metric.progress != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: metric.progress,
                minHeight: 6,
                color: AppColors.secondary,
                backgroundColor: AppColors.surfaceHighest,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            metric.detail,
            style: AppTextStyles.labelCaps.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _SunTime extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _SunTime({
    required this.label,
    required this.value,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelCaps.copyWith(fontSize: 10)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.headingMedium),
      ],
    );
  }
}

class _SunArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..cubicTo(
        size.width * 0.25,
        0,
        size.width * 0.75,
        0,
        size.width,
        size.height,
      );

    final dashedPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), dashedPaint);
        distance = next + dashSpace;
      }
    }

    final sunPaint = Paint()..color = const Color(0xFFFFB4A5);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.34), 5, sunPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

BoxDecoration _detailCardDecoration({bool borderAccent = false}) {
  return BoxDecoration(
    color: AppColors.surfaceHigh.withValues(alpha: 0.88),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.18),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primaryContainer.withValues(alpha: 0.12),
        AppColors.surfaceHigh.withValues(alpha: 0.92),
      ],
    ),
  ).copyWith(
    border: Border.all(
      color: borderAccent ? AppColors.secondary : AppColors.outlineVariant.withValues(alpha: 0.25),
      width: borderAccent ? 1.5 : 1,
    ),
  );
}

WeatherMetric _buildHumidityMetric(CityWeatherSnapshot? snapshot, MoroccoCity city) {
  if (snapshot == null) return city.humidity;
  return WeatherMetric(
    title: 'Humidity',
    value: '${snapshot.current.humidity}%',
    detail: 'Live forecast humidity',
    icon: Icons.water_drop_outlined,
  );
}

WeatherMetric _buildWindMetric(CityWeatherSnapshot? snapshot, MoroccoCity city) {
  if (snapshot == null) return city.wind;
  return WeatherMetric(
    title: 'Wind',
    value: '${(snapshot.current.windSpeedMs * 3.6).round()} km/h',
    detail: 'Live forecast wind',
    icon: Icons.air,
  );
}

WeatherMetric _buildCloudMetric(CityWeatherSnapshot? snapshot, MoroccoCity city) {
  if (snapshot == null) return city.uvIndex;
  return WeatherMetric(
    title: 'Cloud Cover',
    value: '${snapshot.current.cloudCover}%',
    detail: snapshot.current.conditionLabel,
    icon: Icons.cloud_outlined,
    progress: snapshot.current.cloudCover / 100,
  );
}

WeatherMetric _buildVisibilityMetric(MoroccoCity city) {
  return city.visibility;
}

String _formatHour(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  return '$hour:00';
}

String _formatLongDate(DateTime? dateTime) {
  final value = dateTime ?? DateTime.now();
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[value.month - 1]} ${value.day}, ${value.year}';
}

IconData _weatherIcon(String weatherMain, String weatherDescription) {
  final description = weatherDescription.toLowerCase();
  if (weatherMain == 'Clear') return Icons.wb_sunny;
  if (weatherMain == 'Rain' || description.contains('rain')) return Icons.umbrella;
  if (description.contains('overcast')) return Icons.cloud;
  if (weatherMain == 'Wind' || description.contains('wind')) return Icons.air;
  return Icons.cloud_queue;
}
