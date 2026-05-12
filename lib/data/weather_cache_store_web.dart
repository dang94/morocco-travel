// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

Future<String?> readWeatherCache(String cityName) async {
  final normalized = cityName.toLowerCase().replaceAll(' ', '_');
  return html.window.localStorage['morocco_weather_snapshot_$normalized'];
}

Future<void> writeWeatherCache(String cityName, String payload) async {
  final normalized = cityName.toLowerCase().replaceAll(' ', '_');
  html.window.localStorage['morocco_weather_snapshot_$normalized'] = payload;
}
