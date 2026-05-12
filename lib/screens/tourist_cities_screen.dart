import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_header.dart';
import 'city_detail_screen.dart';

class TouristCitiesScreen extends StatefulWidget {
  const TouristCitiesScreen({super.key});

  @override
  State<TouristCitiesScreen> createState() => TouristCitiesScreenState();
}

class TouristCitiesScreenState extends State<TouristCitiesScreen> {
  MoroccoCity? _selectedCity;

  bool handleBack() {
    if (_selectedCity == null) return false;
    setState(() {
      _selectedCity = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCity = _selectedCity;
    if (selectedCity != null) {
      return CityDetailScreen(
        city: selectedCity,
        embedded: true,
        onBack: () {
          setState(() {
            _selectedCity = null;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(title: 'MOROCCO TRAVEL'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          Text('Explore Cities', style: AppTextStyles.headingLarge),
          const SizedBox(height: 8),
          Text(
            'Discover the majestic beauty and weather insights of Morocco\'s most iconic coastal and interior destinations.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 20),
          for (final city in moroccoCities) ...[
            _CityCard(
              city: city,
              featured: city.name == homeCityName,
              onTap: () {
                setState(() {
                  _selectedCity = city;
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final MoroccoCity city;
  final bool featured;
  final VoidCallback onTap;

  const _CityCard({
    required this.city,
    required this.featured,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardHeight = featured ? 270.0 : 224.0;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: cardHeight,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.28)),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                city.imageUrl,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.92),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: AppTextStyles.headingMedium.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        city.tag,
                        style: AppTextStyles.labelCaps.copyWith(
                          color: const Color(0xFFB1C5FF),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
