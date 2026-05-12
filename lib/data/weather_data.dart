import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'travel_data.dart';
import 'weather_cache_store.dart';

class CityWeatherSnapshot {
  final int cacheVersion;
  final WeatherPoint current;
  final List<WeatherPoint> hourlyWindow;
  final List<DailyWeather> nextFiveDays;
  final List<WeatherPoint> forecastTimeline;
  final String sunrise;
  final String sunset;
  final String cityDateKey;
  final int timezoneOffsetSeconds;

  const CityWeatherSnapshot({
    this.cacheVersion = WeatherRepository.cacheFormatVersion,
    required this.current,
    required this.hourlyWindow,
    required this.nextFiveDays,
    required this.forecastTimeline,
    required this.sunrise,
    required this.sunset,
    required this.cityDateKey,
    required this.timezoneOffsetSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'cacheVersion': cacheVersion,
      'current': current.toJson(),
      'hourlyWindow': hourlyWindow.map((item) => item.toJson()).toList(),
      'nextFiveDays': nextFiveDays.map((item) => item.toJson()).toList(),
      'forecastTimeline': forecastTimeline.map((item) => item.toJson()).toList(),
      'sunrise': sunrise,
      'sunset': sunset,
      'cityDateKey': cityDateKey,
      'timezoneOffsetSeconds': timezoneOffsetSeconds,
    };
  }

  factory CityWeatherSnapshot.fromJson(Map<String, dynamic> json) {
    return CityWeatherSnapshot(
      cacheVersion: (json['cacheVersion'] as num?)?.toInt() ?? 1,
      current: WeatherPoint.fromJson(json['current'] as Map<String, dynamic>),
      hourlyWindow: (json['hourlyWindow'] as List<dynamic>)
          .map((item) => WeatherPoint.fromJson(item as Map<String, dynamic>))
          .toList(),
      nextFiveDays: (json['nextFiveDays'] as List<dynamic>)
          .map((item) => DailyWeather.fromJson(item as Map<String, dynamic>))
          .toList(),
      forecastTimeline: (json['forecastTimeline'] as List<dynamic>)
          .map((item) => WeatherPoint.fromJson(item as Map<String, dynamic>))
          .toList(),
      sunrise: json['sunrise'] as String,
      sunset: json['sunset'] as String,
      cityDateKey: json['cityDateKey'] as String,
      timezoneOffsetSeconds: (json['timezoneOffsetSeconds'] as num).toInt(),
    );
  }
}

class WeatherPoint {
  final DateTime dateTime;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeedMs;
  final int cloudCover;
  final String weatherMain;
  final String weatherDescription;
  final bool isCurrent;

  const WeatherPoint({
    required this.dateTime,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeedMs,
    required this.cloudCover,
    required this.weatherMain,
    required this.weatherDescription,
    this.isCurrent = false,
  });

  int get displayTemp => temp.round();

  String get conditionLabel => _toTitleCase(weatherDescription);

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'temp': temp,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeedMs': windSpeedMs,
      'cloudCover': cloudCover,
      'weatherMain': weatherMain,
      'weatherDescription': weatherDescription,
      'isCurrent': isCurrent,
    };
  }

  factory WeatherPoint.fromJson(Map<String, dynamic> json) {
    return WeatherPoint(
      dateTime: DateTime.parse(json['dateTime'] as String),
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeedMs: (json['windSpeedMs'] as num).toDouble(),
      cloudCover: (json['cloudCover'] as num?)?.toInt() ?? 0,
      weatherMain: json['weatherMain'] as String,
      weatherDescription: json['weatherDescription'] as String,
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }
}

class DailyWeather {
  final DateTime date;
  final double high;
  final double low;
  final String weatherMain;
  final String weatherDescription;

  const DailyWeather({
    required this.date,
    required this.high,
    required this.low,
    required this.weatherMain,
    required this.weatherDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'high': high,
      'low': low,
      'weatherMain': weatherMain,
      'weatherDescription': weatherDescription,
    };
  }

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: DateTime.parse(json['date'] as String),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      weatherMain: json['weatherMain'] as String,
      weatherDescription: json['weatherDescription'] as String,
    );
  }
}

class WeatherRepository {
  WeatherRepository._();

  static const int cacheFormatVersion = 3;

  static const String _apiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '7228850b3794cc91f88182d08536c5d4',
  );

  static List<String> get supportedCityNames =>
      moroccoCities.map((city) => city.name).toList(growable: false);

  static Future<CityWeatherSnapshot> loadWeatherForCity(
    MoroccoCity city, {
    bool fetchIfStale = false,
  }) async {
    final fallback = fallbackWeatherSnapshots[city.name]!;
    final cachedJson = await readWeatherCache(city.name);
    CityWeatherSnapshot? cachedSnapshot;

    if (cachedJson != null) {
      try {
        cachedSnapshot = CityWeatherSnapshot.fromJson(
          jsonDecode(cachedJson) as Map<String, dynamic>,
        );
      } catch (_) {
        cachedSnapshot = null;
      }
    }

    if (cachedSnapshot != null &&
        cachedSnapshot.cacheVersion == cacheFormatVersion &&
        cachedSnapshot.cityDateKey ==
            _currentCityDateKey(cachedSnapshot.timezoneOffsetSeconds)) {
      return _resolveSnapshotForNow(cachedSnapshot);
    }

    if (fetchIfStale) {
      try {
        final freshSnapshot = await _fetchForecast(city);
        await writeWeatherCache(city.name, jsonEncode(freshSnapshot.toJson()));
        return _resolveSnapshotForNow(freshSnapshot);
      } catch (_) {
        // Fall back below.
      }
    }

    return _resolveSnapshotForNow(cachedSnapshot ?? fallback);
  }

  static Future<CityWeatherSnapshot> _fetchForecast(MoroccoCity city) async {
    if (_apiKey.isEmpty) {
      throw StateError(
        'OPENWEATHER_API_KEY is not configured. '
        'Pass it with --dart-define=OPENWEATHER_API_KEY=... when running the app.',
      );
    }

    final uri = Uri.https('api.openweathermap.org', '/data/2.5/forecast', {
      'lat': city.latitude.toString(),
      'lon': city.longitude.toString(),
      'appid': _apiKey,
      'units': 'metric',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Forecast request failed: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected forecast response format');
    }

    final payload = decoded;
    final cityJson = payload['city'];
    final listJson = payload['list'];
    if (cityJson is! Map<String, dynamic> || listJson is! List<dynamic>) {
      throw const FormatException('Forecast response is missing fields');
    }

    final timezoneOffsetSeconds = (cityJson['timezone'] as num?)?.toInt() ?? 0;
    final sunrise = _formatHourMinuteFromUnix(
      (cityJson['sunrise'] as num).toInt(),
      timezoneOffsetSeconds,
    );
    final sunset = _formatHourMinuteFromUnix(
      (cityJson['sunset'] as num).toInt(),
      timezoneOffsetSeconds,
    );

    final entries = listJson
        .map((item) => _ForecastEntry.fromJson(item as Map<String, dynamic>))
        .toList();
    final timeline = entries
        .map((entry) => _weatherPointFromEntry(entry, timezoneOffsetSeconds))
        .toList();

    return _resolveSnapshotForNow(
      CityWeatherSnapshot(
        current: timeline.first,
        hourlyWindow: timeline.take(5).toList(),
        nextFiveDays: const [],
        forecastTimeline: timeline,
        sunrise: sunrise,
        sunset: sunset,
        cityDateKey: _currentCityDateKey(timezoneOffsetSeconds),
        timezoneOffsetSeconds: timezoneOffsetSeconds,
      ),
    );
  }

  static CityWeatherSnapshot _resolveSnapshotForNow(CityWeatherSnapshot snapshot) {
    if (snapshot.forecastTimeline.isEmpty) return snapshot;

    final now = DateTime.now()
        .toUtc()
        .add(Duration(seconds: snapshot.timezoneOffsetSeconds));
    final currentIndex = _nearestIndex(snapshot.forecastTimeline, now);
    final hourlyWindow = _buildHourlyWindow(snapshot.forecastTimeline, currentIndex);
    final current = hourlyWindow.firstWhere(
      (entry) => entry.isCurrent,
      orElse: () => hourlyWindow.first,
    );
    final nextFiveDays = _buildNextFiveDays(snapshot.forecastTimeline, current.dateTime);

    return CityWeatherSnapshot(
      cacheVersion: snapshot.cacheVersion,
      current: current,
      hourlyWindow: hourlyWindow,
      nextFiveDays: nextFiveDays,
      forecastTimeline: snapshot.forecastTimeline,
      sunrise: snapshot.sunrise,
      sunset: snapshot.sunset,
      cityDateKey: snapshot.cityDateKey,
      timezoneOffsetSeconds: snapshot.timezoneOffsetSeconds,
    );
  }

  static List<WeatherPoint> _buildHourlyWindow(
    List<WeatherPoint> timeline,
    int currentIndex,
  ) {
    if (timeline.isEmpty) return const [];

    final start = currentIndex.clamp(0, timeline.length - 1);
    final maxItems = min(5, timeline.length - start);

    return List<WeatherPoint>.generate(maxItems, (offset) {
      final source = timeline[start + offset];
      return WeatherPoint(
        dateTime: source.dateTime,
        temp: source.temp,
        feelsLike: source.feelsLike,
        humidity: source.humidity,
        windSpeedMs: source.windSpeedMs,
        cloudCover: source.cloudCover,
        weatherMain: source.weatherMain,
        weatherDescription: source.weatherDescription,
        isCurrent: offset == 0,
      );
    });
  }

  static List<DailyWeather> _buildNextFiveDays(
    List<WeatherPoint> timeline,
    DateTime currentDateTime,
  ) {
    final byDate = <String, List<WeatherPoint>>{};
    for (final point in timeline) {
      final key = _dateKey(point.dateTime);
      byDate.putIfAbsent(key, () => []).add(point);
    }

    final sortedKeys = byDate.keys.toList()..sort();
    final currentKey = _dateKey(currentDateTime);
    final selectedKeys = sortedKeys.where((key) => key.compareTo(currentKey) >= 0).take(5);

    return selectedKeys.map((key) {
      final items = byDate[key]!;
      final representative = [...items]
        ..sort((a, b) {
          final aDistance = (a.dateTime.hour + a.dateTime.minute / 60 - 12).abs();
          final bDistance = (b.dateTime.hour + b.dateTime.minute / 60 - 12).abs();
          return aDistance.compareTo(bDistance);
        });
      final temps = items.map((item) => item.temp).toList();
      final ref = representative.first;

      return DailyWeather(
        date: DateTime.parse(key),
        high: temps.reduce((a, b) => a > b ? a : b),
        low: temps.reduce((a, b) => a < b ? a : b),
        weatherMain: ref.weatherMain,
        weatherDescription: ref.weatherDescription,
      );
    }).toList();
  }

  static int _nearestIndex(List<WeatherPoint> timeline, DateTime now) {
    var bestIndex = 0;
    var bestDistance = timeline.first.dateTime.difference(now).abs();
    for (var index = 1; index < timeline.length; index++) {
      final distance = timeline[index].dateTime.difference(now).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        bestIndex = index;
      }
    }
    return bestIndex;
  }

  static String _currentCityDateKey(int timezoneOffsetSeconds) =>
      _dateKey(DateTime.now().toUtc().add(Duration(seconds: timezoneOffsetSeconds)));

  static String _dateKey(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String _formatHourMinuteFromUnix(int unixSeconds, int timezoneOffsetSeconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      unixSeconds * 1000,
      isUtc: true,
    ).add(Duration(seconds: timezoneOffsetSeconds));
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static WeatherPoint _weatherPointFromEntry(
    _ForecastEntry entry,
    int timezoneOffsetSeconds,
  ) {
    return WeatherPoint(
      dateTime: entry.dateTime.add(Duration(seconds: timezoneOffsetSeconds)),
      temp: entry.temp,
      feelsLike: entry.feelsLike,
      humidity: entry.humidity,
      windSpeedMs: entry.windSpeedMs,
      cloudCover: entry.cloudCover,
      weatherMain: entry.weatherMain,
      weatherDescription: entry.weatherDescription,
    );
  }
}

class _ForecastEntry {
  final DateTime dateTime;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeedMs;
  final int cloudCover;
  final String weatherMain;
  final String weatherDescription;

  const _ForecastEntry({
    required this.dateTime,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeedMs,
    required this.cloudCover,
    required this.weatherMain,
    required this.weatherDescription,
  });

  factory _ForecastEntry.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final wind = json['wind'];
    final clouds = json['clouds'];
    final weatherList = json['weather'];
    final dt = json['dt'];
    final dtTxt = json['dt_txt'];
    if (main is! Map<String, dynamic> ||
        wind is! Map<String, dynamic> ||
        clouds is! Map<String, dynamic> ||
        weatherList is! List<dynamic> ||
        weatherList.isEmpty ||
        dt is! num ||
        dtTxt is! String) {
      throw const FormatException('Invalid forecast entry');
    }

    final weather = weatherList.first as Map<String, dynamic>;
    return _ForecastEntry(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        dt.toInt() * 1000,
        isUtc: true,
      ),
      temp: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: (main['humidity'] as num).toInt(),
      windSpeedMs: (wind['speed'] as num).toDouble(),
      cloudCover: (clouds['all'] as num?)?.toInt() ?? 0,
      weatherMain: (weather['main'] as String?) ?? '',
      weatherDescription: (weather['description'] as String?) ?? '',
    );
  }
}

final Map<String, CityWeatherSnapshot> fallbackWeatherSnapshots = {
  for (final city in moroccoCities) city.name: _fallbackSnapshotForCity(city),
};

CityWeatherSnapshot _fallbackSnapshotForCity(MoroccoCity city) {
  final now = DateTime.now();
  final timeline = _buildFallbackTimeline(now, city.hourlyForecast);
  final hourlyWindow = city.hourlyForecast.asMap().entries.map((entry) {
    final point = entry.value;
    return WeatherPoint(
      dateTime: timeline[entry.key],
      temp: point.temp.toDouble(),
      feelsLike: city.realFeel.toDouble(),
      humidity: _parsePercent(city.humidity.value),
      windSpeedMs: _parseWindKmh(city.wind.value) / 3.6,
      cloudCover: _fallbackCloudCover(point.icon),
      weatherMain: _weatherMainFromIcon(point.icon),
      weatherDescription: _weatherDescriptionFromIcon(point.icon, city.condition),
      isCurrent: point.active,
    );
  }).toList();

  final dailyItems = city.dailyForecast.asMap().entries.map((entry) {
    final point = entry.value;
    return DailyWeather(
      date: DateTime(now.year, now.month, now.day + entry.key),
      high: point.high.toDouble(),
      low: point.low.toDouble(),
      weatherMain: _weatherMainFromIcon(point.icon),
      weatherDescription: _weatherDescriptionFromIcon(point.icon, city.condition),
    );
  }).toList();

  final current = hourlyWindow.firstWhere(
    (item) => item.isCurrent,
    orElse: () => hourlyWindow.first,
  );

  return CityWeatherSnapshot(
    cacheVersion: WeatherRepository.cacheFormatVersion,
    current: current,
    hourlyWindow: hourlyWindow,
    nextFiveDays: dailyItems,
    forecastTimeline: hourlyWindow,
    sunrise: city.sunrise,
    sunset: city.sunset,
    cityDateKey: WeatherRepository._dateKey(now),
    timezoneOffsetSeconds: 0,
  );
}

List<DateTime> _buildFallbackTimeline(
  DateTime now,
  List<HourlyForecastPoint> points,
) {
  if (points.isEmpty) return const [];

  final resolvedHours = <int>[];
  for (var index = 0; index < points.length; index++) {
    final label = points[index].time;
    if (label.toUpperCase() == 'NOW') {
      resolvedHours.add(_fallbackNowHour(points, index));
    } else {
      resolvedHours.add(_hourFromLabel(label, index));
    }
  }

  final timeline = <DateTime>[];
  var dayOffset = 0;
  for (var index = 0; index < resolvedHours.length; index++) {
    if (index > 0 && resolvedHours[index] < resolvedHours[index - 1]) {
      dayOffset += 1;
    }
    timeline.add(
      DateTime(
        now.year,
        now.month,
        now.day + dayOffset,
        resolvedHours[index],
      ),
    );
  }
  return timeline;
}

int _fallbackNowHour(List<HourlyForecastPoint> points, int currentIndex) {
  for (var index = currentIndex + 1; index < points.length; index++) {
    final label = points[index].time;
    if (label.toUpperCase() == 'NOW') continue;
    return (_hourFromLabel(label, index) + 23) % 24;
  }
  return DateTime.now().hour;
}

int _hourFromLabel(String label, int index) {
  final upper = label.toUpperCase();
  if (upper == 'NOW') return DateTime.now().hour;
  final match = RegExp(r'(\d{1,2})').firstMatch(upper);
  if (match == null) return 12 + index;
  var hour = int.parse(match.group(1)!);
  if (upper.contains('PM') && hour < 12) hour += 12;
  if (upper.contains('AM') && hour == 12) hour = 0;
  return hour;
}

int _parsePercent(String value) {
  final match = RegExp(r'(\d+)').firstMatch(value);
  return match == null ? 0 : int.parse(match.group(1)!);
}

double _parseWindKmh(String value) {
  final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(value);
  return match == null ? 0 : double.parse(match.group(1)!);
}

int _fallbackCloudCover(IconData icon) {
  if (icon == Icons.wb_sunny) return 0;
  if (icon == Icons.cloud) return 100;
  if (icon == Icons.cloud_queue) return 60;
  return 30;
}

String _weatherMainFromIcon(IconData icon) {
  if (icon == Icons.wb_sunny) return 'Clear';
  if (icon == Icons.cloud || icon == Icons.cloud_queue) return 'Clouds';
  if (icon == Icons.air) return 'Wind';
  if (icon == Icons.nightlight_round) return 'Clear';
  return 'Clouds';
}

String _weatherDescriptionFromIcon(IconData icon, String fallback) {
  if (icon == Icons.wb_sunny) return 'clear sky';
  if (icon == Icons.cloud) return 'overcast clouds';
  if (icon == Icons.cloud_queue) return 'scattered clouds';
  if (icon == Icons.air) return 'windy';
  if (icon == Icons.nightlight_round) return 'clear sky';
  return fallback.toLowerCase();
}

String _toTitleCase(String value) {
  return value
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
