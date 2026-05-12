import 'package:flutter/material.dart';

class MoroccoCity {
  final String name;
  final String tag;
  final double latitude;
  final double longitude;
  final String description;
  final String imageUrl;
  final String detailImageUrl;
  final String condition;
  final int currentTemp;
  final int realFeel;
  final List<HourlyForecastPoint> hourlyForecast;
  final List<DailyForecastPoint> dailyForecast;
  final WeatherMetric humidity;
  final WeatherMetric wind;
  final WeatherMetric uvIndex;
  final WeatherMetric visibility;
  final String sunrise;
  final String sunset;

  const MoroccoCity({
    required this.name,
    required this.tag,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.imageUrl,
    required this.detailImageUrl,
    required this.condition,
    required this.currentTemp,
    required this.realFeel,
    required this.hourlyForecast,
    required this.dailyForecast,
    required this.humidity,
    required this.wind,
    required this.uvIndex,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

}

class HourlyForecastPoint {
  final String time;
  final IconData icon;
  final int temp;
  final bool active;

  const HourlyForecastPoint({
    required this.time,
    required this.icon,
    required this.temp,
    this.active = false,
  });
}

class DailyForecastPoint {
  final String day;
  final IconData icon;
  final int high;
  final int low;

  const DailyForecastPoint({
    required this.day,
    required this.icon,
    required this.high,
    required this.low,
  });
}

class WeatherMetric {
  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final double? progress;

  const WeatherMetric({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    this.progress,
  });
}

class TravelTip {
  final String category;
  final String title;
  final String? displayTitle;
  final String summary;
  final IconData icon;
  final String heroImageUrl;
  final String readTime;
  final String kicker;
  final String intro;
  final List<TipSection> sections;
  final String? footerTitle;
  final String? footerBody;

  const TravelTip({
    required this.category,
    required this.title,
    this.displayTitle,
    required this.summary,
    required this.icon,
    required this.heroImageUrl,
    required this.readTime,
    required this.kicker,
    required this.intro,
    required this.sections,
    this.footerTitle,
    this.footerBody,
  });
}

class TipSection {
  final String title;
  final IconData icon;
  final String body;
  final String? quote;
  final String? calloutTitle;
  final String? calloutBody;
  final String? secondaryCalloutTitle;
  final String? secondaryCalloutBody;
  final String? imageUrl;
  final String? imageCaption;
  final List<String> bullets;

  const TipSection({
    required this.title,
    required this.icon,
    required this.body,
    this.quote,
    this.calloutTitle,
    this.calloutBody,
    this.secondaryCalloutTitle,
    this.secondaryCalloutBody,
    this.imageUrl,
    this.imageCaption,
    this.bullets = const [],
  });
}

const homeCityName = 'Casablanca';

const moroccoCities = <MoroccoCity>[
  MoroccoCity(
    name: 'Casablanca',
    tag: 'Coastal Metropolis',
    latitude: 33.5731,
    longitude: -7.5898,
    description:
        'A modern Atlantic city anchored by the Hassan II Mosque and breezy ocean promenades.',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDlfn_IvJhygJ5IBUmcHlJvPU7GQJL5nYpNVe0psmuW7bKzPxW3CNAM5HPjaYet0W4QGmv6cbE0O14ArpSiH6QnHp8_hp9Qd8zbp98nkQ2f8I1_nBQE1cU4UeXzVihoir1DKIyw38pTVI_xE5xZOSVkKjza-TE9wpSPBb_jXQHj_E9zTiyVCbmbi0-bk6wk3RO21XpG26Bb1hH3HwiuI8NAOYa5_th2cYVTS4OOYsVe0ibILo7hKVzyq97d8NXma3LPK5jTvtgSc78',
    detailImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDppbDNX5Vb1x9lGpaN0Qy3P40ixLQareSBCuIHsP46RkZrP6HxlozEDduN8wUXuScp9L1ztNsxQOxgpktH8rO3KU6A5mPXUH9hx9zbHbohh3NGBskQ9kFIQWWVt4MNTqovxV8K5whTpX1ZeVQMp-sfG_RPKpsRGNgy_17SximG6yKGmVOq5-MVX8V7cZCgG-KZzAhiHBs54apwt3G5DnjOoRwDYFZUY5nlPIgJZ9RrxSazQvCjW0EThQy_FqoQKwmzA55UUdopkDI',
    condition: 'Sunny',
    currentTemp: 24,
    realFeel: 26,
    hourlyForecast: [
      HourlyForecastPoint(time: 'NOW', icon: Icons.wb_sunny, temp: 24, active: true),
      HourlyForecastPoint(time: '1 PM', icon: Icons.wb_sunny, temp: 25),
      HourlyForecastPoint(time: '2 PM', icon: Icons.cloud_queue, temp: 25),
      HourlyForecastPoint(time: '3 PM', icon: Icons.wb_sunny, temp: 24),
      HourlyForecastPoint(time: '4 PM', icon: Icons.wb_sunny, temp: 23),
      HourlyForecastPoint(time: '5 PM', icon: Icons.cloud_queue, temp: 21),
      HourlyForecastPoint(time: '6 PM', icon: Icons.nightlight_round, temp: 19),
    ],
    dailyForecast: [
      DailyForecastPoint(day: 'Today', icon: Icons.wb_sunny, high: 24, low: 16),
      DailyForecastPoint(day: 'Tomorrow', icon: Icons.cloud_queue, high: 22, low: 15),
      DailyForecastPoint(day: 'Day 3', icon: Icons.wb_sunny, high: 26, low: 17),
      DailyForecastPoint(day: 'Day 4', icon: Icons.cloud, high: 21, low: 14),
      DailyForecastPoint(day: 'Day 5', icon: Icons.wb_sunny, high: 25, low: 16),
    ],
    humidity: WeatherMetric(
      title: 'Humidity',
      value: '62%',
      detail: 'Dew point is 14°',
      icon: Icons.water_drop_outlined,
    ),
    wind: WeatherMetric(
      title: 'Wind',
      value: '18 km/h',
      detail: 'From North-West',
      icon: Icons.air,
    ),
    uvIndex: WeatherMetric(
      title: 'UV Index',
      value: '4',
      detail: 'Moderate risk',
      icon: Icons.light_mode_outlined,
      progress: 0.4,
    ),
    visibility: WeatherMetric(
      title: 'Visibility',
      value: '10 km',
      detail: 'Perfectly clear',
      icon: Icons.visibility_outlined,
    ),
    sunrise: '06:42',
    sunset: '18:54',
  ),
  MoroccoCity(
    name: 'Marrakech',
    tag: 'Red City',
    latitude: 31.6295,
    longitude: -7.9811,
    description:
        'Terracotta lanes, riad courtyards, and market energy framed by Atlas light.',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAXvKTKhiUjtyhGpLnHDnPRhtYQoSSA8lsDFwiZVHZgwONDWpdlIcDvNvSQNwbNPPaZalvmckgaVMfoNslGgwbChIazj0VFC-XCp0LUhfljXvdxfcK-OBYDvXMx1mhF2fAFjhnpj3Dm2F21uWE4AC2LXZZbiQKJNH26mxaAkQTlzecmn18GJHf7Q1KIU3YNEPH2sg76ncz_FY8MbsP86qxfAAj8o3RWujdHl9hTeizCqSztlQ8Wn8LS33B6XszKE-L4Pp1bJ6bfOR8',
    detailImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAXvKTKhiUjtyhGpLnHDnPRhtYQoSSA8lsDFwiZVHZgwONDWpdlIcDvNvSQNwbNPPaZalvmckgaVMfoNslGgwbChIazj0VFC-XCp0LUhfljXvdxfcK-OBYDvXMx1mhF2fAFjhnpj3Dm2F21uWE4AC2LXZZbiQKJNH26mxaAkQTlzecmn18GJHf7Q1KIU3YNEPH2sg76ncz_FY8MbsP86qxfAAj8o3RWujdHl9hTeizCqSztlQ8Wn8LS33B6XszKE-L4Pp1bJ6bfOR8',
    condition: 'Clear',
    currentTemp: 28,
    realFeel: 29,
    hourlyForecast: [
      HourlyForecastPoint(time: 'NOW', icon: Icons.wb_sunny, temp: 28, active: true),
      HourlyForecastPoint(time: '1 PM', icon: Icons.wb_sunny, temp: 29),
      HourlyForecastPoint(time: '2 PM', icon: Icons.wb_sunny, temp: 29),
      HourlyForecastPoint(time: '3 PM', icon: Icons.wb_sunny, temp: 28),
      HourlyForecastPoint(time: '4 PM', icon: Icons.wb_sunny, temp: 26),
    ],
    dailyForecast: [
      DailyForecastPoint(day: 'Today', icon: Icons.wb_sunny, high: 28, low: 18),
      DailyForecastPoint(day: 'Tomorrow', icon: Icons.wb_sunny, high: 29, low: 17),
      DailyForecastPoint(day: 'Day 3', icon: Icons.wb_sunny, high: 30, low: 18),
      DailyForecastPoint(day: 'Day 4', icon: Icons.cloud_queue, high: 27, low: 16),
      DailyForecastPoint(day: 'Day 5', icon: Icons.wb_sunny, high: 28, low: 17),
    ],
    humidity: WeatherMetric(
      title: 'Humidity',
      value: '38%',
      detail: 'Dry afternoon air',
      icon: Icons.water_drop_outlined,
    ),
    wind: WeatherMetric(
      title: 'Wind',
      value: '12 km/h',
      detail: 'Warm southern breeze',
      icon: Icons.air,
    ),
    uvIndex: WeatherMetric(
      title: 'UV Index',
      value: '7',
      detail: 'High exposure',
      icon: Icons.light_mode_outlined,
      progress: 0.7,
    ),
    visibility: WeatherMetric(
      title: 'Visibility',
      value: '9 km',
      detail: 'Clear city skyline',
      icon: Icons.visibility_outlined,
    ),
    sunrise: '06:58',
    sunset: '19:02',
  ),
  MoroccoCity(
    name: 'Fes',
    tag: 'Imperial Heritage',
    latitude: 34.0331,
    longitude: -5.0003,
    description:
        'Dense medina geometry, artisan courtyards, and layered dawn light over old rooftops.',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAxzoNikWrnXzZDf17uBl7pQhd9pYy4DXYt5qaCEUmZqXC9t5xo8b6t89cRHD40XsmsfLYcNqUK4KFMvOCqT1fE-cpPm4qMU6-4uqY_wlnxyxuz3zAfvIFMyIlnqqBMOzstu_rR6wN1ulple4yixynEu6Plv0VSvz5tW4IdQB6ciIlLD-T97VE-m5l-HiZJEadbHSC6xF74_Inm9QrICtMwTpt3iflWjgsfX7o6F9Y2DRhQLWAJQa1N45atz6yvAOoyxeJFOiD-I9U',
    detailImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAxzoNikWrnXzZDf17uBl7pQhd9pYy4DXYt5qaCEUmZqXC9t5xo8b6t89cRHD40XsmsfLYcNqUK4KFMvOCqT1fE-cpPm4qMU6-4uqY_wlnxyxuz3zAfvIFMyIlnqqBMOzstu_rR6wN1ulple4yixynEu6Plv0VSvz5tW4IdQB6ciIlLD-T97VE-m5l-HiZJEadbHSC6xF74_Inm9QrICtMwTpt3iflWjgsfX7o6F9Y2DRhQLWAJQa1N45atz6yvAOoyxeJFOiD-I9U',
    condition: 'Cloudy',
    currentTemp: 19,
    realFeel: 18,
    hourlyForecast: [
      HourlyForecastPoint(time: 'NOW', icon: Icons.cloud, temp: 19, active: true),
      HourlyForecastPoint(time: '1 PM', icon: Icons.cloud, temp: 20),
      HourlyForecastPoint(time: '2 PM', icon: Icons.cloud_queue, temp: 20),
      HourlyForecastPoint(time: '3 PM', icon: Icons.cloud, temp: 19),
    ],
    dailyForecast: [
      DailyForecastPoint(day: 'Today', icon: Icons.cloud, high: 19, low: 11),
      DailyForecastPoint(day: 'Tomorrow', icon: Icons.cloud_queue, high: 18, low: 10),
      DailyForecastPoint(day: 'Day 3', icon: Icons.wb_sunny, high: 21, low: 12),
      DailyForecastPoint(day: 'Day 4', icon: Icons.cloud, high: 17, low: 9),
      DailyForecastPoint(day: 'Day 5', icon: Icons.wb_sunny, high: 20, low: 11),
    ],
    humidity: WeatherMetric(
      title: 'Humidity',
      value: '68%',
      detail: 'Cool morning moisture',
      icon: Icons.water_drop_outlined,
    ),
    wind: WeatherMetric(
      title: 'Wind',
      value: '9 km/h',
      detail: 'Sheltered medina air',
      icon: Icons.air,
    ),
    uvIndex: WeatherMetric(
      title: 'UV Index',
      value: '3',
      detail: 'Low to moderate',
      icon: Icons.light_mode_outlined,
      progress: 0.3,
    ),
    visibility: WeatherMetric(
      title: 'Visibility',
      value: '8 km',
      detail: 'Soft morning haze',
      icon: Icons.visibility_outlined,
    ),
    sunrise: '06:49',
    sunset: '18:47',
  ),
  MoroccoCity(
    name: 'Chefchaouen',
    tag: 'Blue Mountain City',
    latitude: 35.1688,
    longitude: -5.2636,
    description:
        'Calm blue alleys, Rif air, and soft mountain light built for slower travel days.',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC3gVjEnXwSWZTPSKElQXeooZmIfW7QhugzYUfHoWhd3ayXR36cy0lB6KEl8Khrjm3avbVXmxk4hHPb7V12AM29gkQtlMQJfhxjXRhA5BOgCjGIYmuWqtVPnbvwfKIpbFVmsX5vTd1SKYtdBjwsz5o_UAIw__r9HRCmdmWkvRpIIYEw96Gv_u20c9ttKKJL2HIJbvnH_ahI74o-fJzsAIA3Ihhix3-GGD20cRaIJRfpioP_J3ApvpqUro9rvnKLQpJv7O1JyeEqLME',
    detailImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC3gVjEnXwSWZTPSKElQXeooZmIfW7QhugzYUfHoWhd3ayXR36cy0lB6KEl8Khrjm3avbVXmxk4hHPb7V12AM29gkQtlMQJfhxjXRhA5BOgCjGIYmuWqtVPnbvwfKIpbFVmsX5vTd1SKYtdBjwsz5o_UAIw__r9HRCmdmWkvRpIIYEw96Gv_u20c9ttKKJL2HIJbvnH_ahI74o-fJzsAIA3Ihhix3-GGD20cRaIJRfpioP_J3ApvpqUro9rvnKLQpJv7O1JyeEqLME',
    condition: 'Partly cloudy',
    currentTemp: 17,
    realFeel: 16,
    hourlyForecast: [
      HourlyForecastPoint(time: 'NOW', icon: Icons.cloud_queue, temp: 17, active: true),
      HourlyForecastPoint(time: '1 PM', icon: Icons.cloud_queue, temp: 18),
      HourlyForecastPoint(time: '2 PM', icon: Icons.cloud_queue, temp: 18),
      HourlyForecastPoint(time: '3 PM', icon: Icons.wb_sunny, temp: 19),
    ],
    dailyForecast: [
      DailyForecastPoint(day: 'Today', icon: Icons.cloud_queue, high: 17, low: 9),
      DailyForecastPoint(day: 'Tomorrow', icon: Icons.cloud_queue, high: 18, low: 10),
      DailyForecastPoint(day: 'Day 3', icon: Icons.wb_sunny, high: 20, low: 11),
      DailyForecastPoint(day: 'Day 4', icon: Icons.cloud_queue, high: 18, low: 10),
      DailyForecastPoint(day: 'Day 5', icon: Icons.wb_sunny, high: 21, low: 12),
    ],
    humidity: WeatherMetric(
      title: 'Humidity',
      value: '71%',
      detail: 'Mountain mist persists',
      icon: Icons.water_drop_outlined,
    ),
    wind: WeatherMetric(
      title: 'Wind',
      value: '11 km/h',
      detail: 'Rif hillside breeze',
      icon: Icons.air,
    ),
    uvIndex: WeatherMetric(
      title: 'UV Index',
      value: '4',
      detail: 'Moderate daylight',
      icon: Icons.light_mode_outlined,
      progress: 0.4,
    ),
    visibility: WeatherMetric(
      title: 'Visibility',
      value: '7 km',
      detail: 'Light mountain haze',
      icon: Icons.visibility_outlined,
    ),
    sunrise: '06:44',
    sunset: '18:41',
  ),
  MoroccoCity(
    name: 'Essaouira',
    tag: 'Atlantic Escape',
    latitude: 31.5085,
    longitude: -9.7595,
    description:
        'Wind, salt air, fishing boats, and a calmer coastal rhythm along the ramparts.',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCAE1VkKond8zBy8VZXacjgX95O_q5nFFAVmufRsgrkCzdrh42DWv8KDwn5WQup11atsbK2WN7esmgYcRd6zFjPlGrsvsnXAXWu-nSJshE7CnTNhoYPV0xnWka4QZL1CEiKw74uxkiIwnhnuaBQAqyG57tYxaj7NRd2K4FZ7BjyGNkqrYZd8Bhs9jw6ngVUESW5cn_vhxlCSErqnOZ7XiFazfmTeUV0soNgNXSWGDdM7ogp0BhEuhMUDLKlMavX3mTYBqbWgF3Jp10',
    detailImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCAE1VkKond8zBy8VZXacjgX95O_q5nFFAVmufRsgrkCzdrh42DWv8KDwn5WQup11atsbK2WN7esmgYcRd6zFjPlGrsvsnXAXWu-nSJshE7CnTNhoYPV0xnWka4QZL1CEiKw74uxkiIwnhnuaBQAqyG57tYxaj7NRd2K4FZ7BjyGNkqrYZd8Bhs9jw6ngVUESW5cn_vhxlCSErqnOZ7XiFazfmTeUV0soNgNXSWGDdM7ogp0BhEuhMUDLKlMavX3mTYBqbWgF3Jp10',
    condition: 'Breezy',
    currentTemp: 21,
    realFeel: 20,
    hourlyForecast: [
      HourlyForecastPoint(time: 'NOW', icon: Icons.air, temp: 21, active: true),
      HourlyForecastPoint(time: '1 PM', icon: Icons.wb_sunny, temp: 22),
      HourlyForecastPoint(time: '2 PM', icon: Icons.wb_sunny, temp: 22),
      HourlyForecastPoint(time: '3 PM', icon: Icons.cloud_queue, temp: 21),
    ],
    dailyForecast: [
      DailyForecastPoint(day: 'Today', icon: Icons.wb_sunny, high: 21, low: 15),
      DailyForecastPoint(day: 'Tomorrow', icon: Icons.cloud_queue, high: 22, low: 16),
      DailyForecastPoint(day: 'Day 3', icon: Icons.wb_sunny, high: 23, low: 16),
      DailyForecastPoint(day: 'Day 4', icon: Icons.cloud, high: 20, low: 15),
      DailyForecastPoint(day: 'Day 5', icon: Icons.wb_sunny, high: 22, low: 16),
    ],
    humidity: WeatherMetric(
      title: 'Humidity',
      value: '66%',
      detail: 'Atlantic moisture',
      icon: Icons.water_drop_outlined,
    ),
    wind: WeatherMetric(
      title: 'Wind',
      value: '23 km/h',
      detail: 'Strong ocean breeze',
      icon: Icons.air,
    ),
    uvIndex: WeatherMetric(
      title: 'UV Index',
      value: '5',
      detail: 'Steady coastal sun',
      icon: Icons.light_mode_outlined,
      progress: 0.5,
    ),
    visibility: WeatherMetric(
      title: 'Visibility',
      value: '11 km',
      detail: 'Wide coastal clarity',
      icon: Icons.visibility_outlined,
    ),
    sunrise: '06:59',
    sunset: '19:08',
  ),
];

const travelTips = <TravelTip>[
  TravelTip(
    category: 'Packing',
    title: 'Packing Essentials',
    displayTitle: 'The Ultimate Moroccan Packing List',
    summary:
        'From breathable linens in the medinas to insulating layers for High Atlas nights.',
    icon: Icons.luggage,
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBlDRpV-ObkLpqbj5h1lW-Oe_YckQBV68vRXMhMstUFdfM2ia1qD1YPdy3M9B5Uhr1BvbIFPQELM6jEFnZv3Mf0hl_3isAnUy1QopK2E25Jgg3HoKvoW7or1wFMldx1Q2ItZ_CiCWpwBRO_Yls0Rzw4Jtf8ORd3I1ia_dTIVG5NLw_8r70W0ZOKZZj6rumnfRo-JuR3D0pHeQ2Hv9RARClJkgRTQBHYUmvJZvG3YkJ4-ayNmunHWv8IkESkdlaM8_1yFDBD5nJduiI',
    readTime: '8 min read',
    kicker: 'Travel Tips',
    intro:
        'From the bustling heat of the medinas to the freezing nights of the High Atlas, versatility is your greatest asset.',
    sections: [
      TipSection(
        title: 'Clothing',
        icon: Icons.checkroom,
        body:
            'In the winding medinas of Fes or Marrakech, airflow is essential. Pack lightweight linen shirts and wide-leg trousers to remain modest while staying cool under the African sun. The mountains demand respect, and even in summer, nights at high altitude drop significantly.',
        calloutTitle: 'Breathable Linens',
        calloutBody:
            'Choose fabrics that stay cool in dense city streets and covered souks.',
        secondaryCalloutTitle: 'Atlas Layers',
        secondaryCalloutBody:
            'A packable down jacket or heavy merino layer is non-negotiable for trekkers.',
      ),
      TipSection(
        title: 'Footwear',
        icon: Icons.hiking,
        body:
            'The uneven cobblestones of the souks and the dusty trails of the Sahara require versatile shoes. A pair of broken-in hiking boots and stylish, supportive sandals are essential.',
        quote:
            'Never wear new shoes to Morocco. The miles add up quickly, and those medina walls are unforgiving on unseasoned feet.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCfCwq26MPCjIm4s3WWwjzizYseRN6pFzqLZ4MEIxFGUA6w7_9BjPWWVufQb_WIzi6UGD0e9plSqXIFKOA73pOZIJ8H9XbgvNvijKzcviUdhNV6bXNKji_Ec_2sBswPp0UlhxiQ77mL10PmdL77wDqBIZ7-lUiIN27oDGrnsYVm1xeHKR1KKfe76m1QmZYjhpDrxppMZD5SA9ciJYYZGE5ZDOOEY9LhAMuRBpBKuj3G6SZ2xMLP_fVYlszH0BNf_lG4oYwqxHPY66c',
        imageCaption:
            'Break in your shoes before arrival. Medina mileage adds up quickly.',
      ),
      TipSection(
        title: 'Tech & Gear',
        icon: Icons.devices_outlined,
        body:
            'Keep the practical layer of your kit compact and dependable. Morocco rewards small, well-chosen tools more than overpacking.',
        bullets: [
          'Type C/E adapter for standard European two-pin plugs.',
          'Power bank for long transfer days and heavy photo use.',
          'Circular polarizer for reducing intense Saharan glare and haze.',
        ],
      ),
      TipSection(
        title: 'Essential Scarf',
        icon: Icons.waves_outlined,
        body:
            'The most versatile item you will own. It protects from sand and sun, and works as a modest wrap for mosques or cool evenings.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCjhtTT21z5yjRM7fYMvzwKhdqlmLgnmUp1B9bco9U-JjPSypCAIHMDuKHkNFxrtdSgP5MxZpGGoRVOr8oq0DwjmGjjlI7TsezeIzXg9GMdjZLEjuXSK-81kh-5LeW0D4BfpammpftjSYmrjLmQe9btddFEn4vJrZH6biqHDQ3q8CAswWzEEZtIYFKHLopZgBd92eYLQXDkqPM5RKZF38BqmnFJqfkFfKnlRB1-mo-SCRg6XLVxFxa0LvV_FOdw9Ffcbx2KXCQZ6Y0',
        imageCaption:
            'A good scarf moves easily between desert, city, and sacred spaces.',
      ),
    ],
  ),
  TravelTip(
    category: 'Currency',
    title: 'Currency Tips',
    displayTitle: 'Navigating the Dirham',
    summary:
        'Navigating the Dirham, balancing cash vs card, and avoiding friction in the souks.',
    icon: Icons.payments,
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA9tpeHYAFJvkrnEoLwqff9ddtDhAe88ODVLQ9amtmTuHjjwRRXKjK4ji7Ce5WVkB4sHC0nWe8P484DqCh1TJtFQF2xpvZHJltS0mgujYGWUj_hFGvm9AI73qcrbQXc4T_HOkYSIdxloOLZcy_1zwig1GxJBrHQLrNdsqD9fYnpcnUl58GewHtawhbbv-CMXlnOPldCJaDJaBH5c6O8WJJSE7gSdLRZTK-O2VsVcNyLqR-QNzsPEguGAoVIy5MiAqZ8Hw5nEP9aH-w',
    readTime: '5 min read',
    kicker: 'Travel Tips',
    intro:
        'The Moroccan Dirham (MAD) is a closed currency, meaning you cannot easily buy or sell it outside Morocco. Mastering exchange and understanding where to use cash versus cards is essential.',
    sections: [
      TipSection(
        title: 'Riad Tipping',
        icon: Icons.currency_exchange,
        body:
            'In riads, tipping is a gesture of appreciation for intimate service. A practical rule is 50-100 MAD per day for staff, usually left in a common tip box or handed to the manager at checkout.',
      ),
      TipSection(
        title: 'Souk Exchange Rates',
        icon: Icons.storefront_outlined,
        body:
            'While ATMs are widely available in Ville Nouvelle districts, smaller exchange kiosks near major medina gates often offer better rates than hotels or airport counters.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD3SQl3mG543Y2KnjOS4dX5-4_ZjURUTEFWv50R8Kkdnp_P4kYgU2rgyO4zeD0fhG3fX3MG_hNp8aHpbV-nQMQJ_IruOe0lPxUCkxHfLeWfMI9eiAdKsOGf7ODgloJTq5rjpanPv5BpqQZL-WS9R2cQS6_VT_kn6Xwc12oqGg5GmHMTWhyYgAOZcUrayDU7z503xIByujCXjW4ZtxUZcHnyzYqOS7C3swp2RVH4sV0uSV7su5ARJjSli9jYOahffprAWLEHK4ibDJY',
        imageCaption:
            'Souks reward patience. Exchange once, then spend steadily and deliberately.',
        calloutTitle: 'Pro Tip: Cash vs. Card',
        calloutBody:
            'Morocco remains cash-heavy. Luxury hotels and high-end restaurants may accept major cards, but most souk purchases, taxis, and street food still require Dirhams. Keep at least 500 MAD in small bills for daily spending.',
      ),
      TipSection(
        title: 'Recommended Exchange Points',
        icon: Icons.map_outlined,
        body:
            'Use bank-affiliated counters, trusted kiosks near medina gates, or reputable hotel desks. Avoid treating the airport as your only exchange strategy if you are continuing into dense city areas.',
      ),
    ],
  ),
  TravelTip(
    category: 'Culture',
    title: 'Cultural Etiquette',
    displayTitle: 'Navigating the Soul of Morocco',
    summary:
        'Hospitality, modesty, photography ethics, and the right way to decline with grace.',
    icon: Icons.diversity_3,
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuABaEghqlmXWL_VD9v67fxf8Zscy1a2Hh_L-i26IKE9dqW8pfnIrAeIPzHSYuSCTtF1QcR85ecFujTqwDWgFzsOZ7cae51p6SxSkgL3R7oNZ8VZJcI9BHgvt1xuV3kf9CPTtwWP1Ev5t8SNI7JIX8YmL3LS37midEeybhhKCT8NwY-V9-CfphOcLyXcW5CEVGDSKCSpZ2NdzXKmkoc4JeD8AvZneeA9_NKN7RbnAUN-x_1SYVYGFr1Zdisq_nC82Bo1KBnIPgalpFc',
    readTime: '6 min read',
    kicker: 'Travel Tips',
    intro:
        'Moroccan culture is a beautiful tapestry of Arab, Berber, and French influences, deeply rooted in hospitality and respect.',
    sections: [
      TipSection(
        title: 'Hospitality and Greetings',
        icon: Icons.celebration_outlined,
        body:
            'When entering a home, it is customary to remove your shoes. Greetings are often lengthy, involving inquiries about health and family, and moving too quickly can read as indifference rather than efficiency.',
        quote:
            'To be a guest in a Moroccan home is to be treated like royalty. Reciprocating this warmth with humility is the key to deep cultural connection.',
      ),
      TipSection(
        title: 'Photography Ethics',
        icon: Icons.photo_camera_outlined,
        body:
            'Always ask for permission before photographing people, especially in the souks. A simple nod and showing your camera is often enough. Respect signs that prohibit photography in religious sites.',
      ),
      TipSection(
        title: 'Declining Vendors',
        icon: Icons.handshake_outlined,
        body:
            'Vendors in the medina can be persistent. A polite but firm "La Shukran" with a hand over your heart is the most respectful way to decline without causing offense.',
      ),
      TipSection(
        title: 'Social Etiquette & Dress',
        icon: Icons.checkroom_outlined,
        body:
            'Modesty is highly valued. In rural areas or religious sites, ensure shoulders and knees are covered. Even in more liberal cities, conservative dress usually creates smoother interactions and signals respect.',
      ),
    ],
  ),
  TravelTip(
    category: 'Seasons',
    title: 'Best Travel Seasons',
    displayTitle: 'When to Experience the Magic of Morocco',
    summary:
        'When to visit for Atlas blossoms, Sahara nights, and cooler coastal breezes.',
    icon: Icons.calendar_month,
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDsJnZBVQOtVjl-82AzOi6SbiFdIL5501LSX3jZAW0efYOnGU9h7SxEGmb6sH9E98h8-gQS5aV-YQA3Flnf6UAyOPxY2gDAn8PXHsjY41iRYze1qFnWWFnKVf_6KKoOzxoKi5YywDpM5iiZT8yw7-Hf0AQ4xYMBFVm9tCQVUf8fTjZI6aRYre-4BPXuv7t2yYf94z2CWYYDO6GljGGXh_m-0NmrWbA0O84RSY6yp8q3DksgPbtycE-3YOYSKWhMAxxZbf24yJ6_mDk',
    readTime: '8 min read',
    kicker: 'Travel Tips',
    intro:
        'Morocco is a land of extremes, from the snow-capped High Atlas to the scorching dunes of the Sahara. Finding the right window helps you experience the country at its most vibrant without the overwhelming intensity of peak summer.',
    sections: [
      TipSection(
        title: 'Spring Blossoms',
        icon: Icons.local_florist,
        body:
            'The most coveted time. Landscapes are lush and green, with pleasant temperatures perfect for trekking the Atlas or exploring the medinas.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBiwL9_ofbzrvJvkIryv6llLc7r1jVf7H2IRZViBpqLC9qVDyXO0zwb_WgRtkJUvi2qjgwyASQVQIrH5E7e3hucLIpIadg7Rb1oSSiXrw_dILwWW3cR4a1ou-mzVFpIuUfFqIsVuWW3wKRznCQ_koMjgC6Iu3biZGyNnWeAFXMGI2wUb3Oa3Ny-irE_-fL3YSH1-auGlPPtshMe9-TkvELRuJ71Tl13Hz5b41ODLs6ZjlsCAS2t2lrRvOH3gjTwOi-PfPVvRpzyZO0',
        imageCaption: 'Typical range: 18°C - 25°C',
      ),
      TipSection(
        title: 'Autumn Gold',
        icon: Icons.eco,
        body:
            'As the summer heat fades, the air clears and the golden hour becomes truly magical. It is ideal for Saharan expeditions and coastal retreats.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCfKDe1XW2VD8wwW7sgB_w3vvc7rrN6eRfBbiSfDFSbnD-cWBrrj1HIK9o0JXgvn7R9lagfhiWUrN2MgyGJkzUdodLp459_I0s9Uz_D9RI01ZXP87-6rop9Vj_VyzidxWi1XnxLpxSDXsaF7nS1NZaJ-vl_zt4MjKdtv9HdRsVLH50xhIJXspqioWjIlVDnFMdbDyEJpLbl8me6TWe8Llsw6fpYDzVl9P3u1P1ovhYgGfw7SE3c2FRbGxWuCU_Hv1yHgKdBxqKUnaU',
        imageCaption: 'Typical range: 20°C - 28°C',
      ),
      TipSection(
        title: 'Winter Serenity',
        icon: Icons.ac_unit,
        body:
            'Cooler days and crisp nights bring a quieter rhythm. This is the season for fireplace-lit riads, moody coastlines, and the unusual sight of snow near the desert edge.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCjdGevsFJrRx0TlRRnQwgf-PszVgGDiTvqP9i_siJEqA3vaBuVnbsE_364j_nNqlVAvAEVr-Qh6gya8cixa4lK3dwMUKWh9kW39ovW5YKwNA9St415vXgE4DcADhV4ycQnBXXkwpFew4BIAiXoSrTHekdh4LECYM-eCdYF9Z2-nY5AJpABU0BfP7qiWcdlU2ndN__O7zu47CP5rTj82PmVrWKlL93zb1aZirI5P212s23LQp0GAIR8q5SeE2qPOu0o2AH2PKPO7nI',
        imageCaption: 'Typical range: 8°C - 18°C',
        calloutTitle: 'Insider Tip: The Ramadan Factor',
        calloutBody:
            'Traveling during Ramadan offers a unique cultural perspective, but be prepared for adjusted opening hours and quieter afternoons. Evening iftar celebrations are especially memorable for food-focused travelers.',
      ),
    ],
  ),
];
