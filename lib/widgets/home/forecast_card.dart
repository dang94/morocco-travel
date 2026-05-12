import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ForecastCard extends StatelessWidget {
  final String day;
  final IconData icon;
  final int high;
  final int low;
  final bool active;

  const ForecastCard({
    super.key,
    required this.day,
    required this.icon,
    required this.high,
    required this.low,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = active ? AppColors.textPrimary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(
              day,
              style: AppTextStyles.bodyMedium.copyWith(color: textColor),
            ),
          ),
          Expanded(
            child: Center(
              child: Icon(icon, color: AppColors.secondary, size: 22),
            ),
          ),
          SizedBox(
            width: 80,
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
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
