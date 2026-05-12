import 'dart:io';

Future<String?> readWeatherCache(String cityName) async {
  final file = _cacheFile(cityName);
  if (!await file.exists()) return null;
  return file.readAsString();
}

Future<void> writeWeatherCache(String cityName, String payload) async {
  final file = _cacheFile(cityName);
  await file.parent.create(recursive: true);
  await file.writeAsString(payload);
}

File _cacheFile(String cityName) {
  final normalized = cityName.toLowerCase().replaceAll(' ', '_');
  return File(
    '${Directory.systemTemp.path}${Platform.pathSeparator}morocco_travel_weather${Platform.pathSeparator}weather_snapshot_$normalized.json',
  );
}
