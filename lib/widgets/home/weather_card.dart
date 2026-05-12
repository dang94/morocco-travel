import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class WeatherCard extends StatelessWidget {
  final String imageUrl;
  final String city;
  final int temp;
  final String condition;
  final String dateLabel;

  const WeatherCard({
    super.key,
    required this.imageUrl,
    required this.city,
    required this.temp,
    required this.condition,
    this.dateLabel = 'Friday, Oct 27',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 530,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.08),
                    AppColors.background.withValues(alpha: 0.38),
                    AppColors.background.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.12),
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
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(city, style: AppTextStyles.display.copyWith(fontSize: 30)),
                            const SizedBox(height: 4),
                            Text(
                              '$condition \u2022 $dateLabel',
                              style: AppTextStyles.labelCaps.copyWith(
                                color: AppColors.secondary,
                                letterSpacing: 0.18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$temp\u00B0',
                        style: AppTextStyles.dataDisplay.copyWith(
                          color: AppColors.textPrimary,
                        ),
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
