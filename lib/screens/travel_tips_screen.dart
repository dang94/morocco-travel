import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_header.dart';

class TravelTipsScreen extends StatefulWidget {
  const TravelTipsScreen({super.key});

  @override
  State<TravelTipsScreen> createState() => TravelTipsScreenState();
}

class TravelTipsScreenState extends State<TravelTipsScreen> {
  TravelTip? _selectedTip;

  bool handleBack() {
    if (_selectedTip == null) return false;
    setState(() {
      _selectedTip = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final selectedTip = _selectedTip;
    if (selectedTip != null) {
      return _TravelTipDetailView(
        tip: selectedTip,
        onBack: () {
          setState(() {
            _selectedTip = null;
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
          _HeroBanner(imageUrl: travelTips.first.heroImageUrl),
          const SizedBox(height: 20),
          for (final tip in travelTips) ...[
            _TipCard(
              tip: tip,
              featured: tip == travelTips.first,
              onTap: () {
                setState(() {
                  _selectedTip = tip;
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

class _HeroBanner extends StatelessWidget {
  final String imageUrl;

  const _HeroBanner({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover, filterQuality: FilterQuality.medium),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Essential Wisdom', style: AppTextStyles.headingLarge),
                  const SizedBox(height: 6),
                  const Text(
                    'Curated insights for the discerning traveler navigating the Maghreb.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
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

class _TipCard extends StatelessWidget {
  final TravelTip tip;
  final bool featured;
  final VoidCallback onTap;

  const _TipCard({
    required this.tip,
    required this.featured,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(tip.icon, color: AppColors.secondary, size: 22),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tip.category.toUpperCase(),
                    style: AppTextStyles.labelCaps.copyWith(
                      color: AppColors.secondary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              tip.title,
              style: AppTextStyles.headingMedium.copyWith(
                fontSize: featured ? 22 : 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(tip.summary, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 18),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Read More',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: AppColors.secondary, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelTipDetailView extends StatelessWidget {
  final TravelTip tip;
  final VoidCallback onBack;

  const _TravelTipDetailView({
    required this.tip,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: 'MOROCCO TRAVEL',
        showBackButton: true,
        onBackTap: onBack,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        children: [
          Container(
            height: 320,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(tip.heroImageUrl, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.78),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tip.kicker.toUpperCase(),
                  style: AppTextStyles.labelCaps.copyWith(color: const Color(0xFF94F0B2)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tip.displayTitle ?? tip.title,
            style: AppTextStyles.display.copyWith(fontSize: 42, height: 1.08),
          ),
          const SizedBox(height: 8),
          Text(
            tip.intro,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          for (final section in tip.sections) ...[
            _TipSectionCard(section: section),
            const SizedBox(height: 24),
          ],
          if (tip.footerTitle != null && tip.footerBody != null) ...[
            _FooterCallout(
              title: tip.footerTitle!,
              body: tip.footerBody!,
            ),
          ],
        ],
      ),
    );
  }
}

class _TipSectionCard extends StatelessWidget {
  final TipSection section;

  const _TipSectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.58),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.22)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(section.icon, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      section.title,
                      style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(section.body, style: AppTextStyles.bodyMedium.copyWith(height: 1.7)),
              if (section.quote != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: AppColors.primary, width: 4),
                    ),
                    color: AppColors.primaryContainer.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '"${section.quote!}"',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
              if (section.calloutTitle != null && section.calloutBody != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _CalloutBox(
                        title: section.calloutTitle!,
                        body: section.calloutBody!,
                        accent: AppColors.secondary,
                        background: AppColors.secondaryContainer.withValues(alpha: 0.15),
                      ),
                    ),
                    if (section.secondaryCalloutTitle != null &&
                        section.secondaryCalloutBody != null) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: _CalloutBox(
                          title: section.secondaryCalloutTitle!,
                          body: section.secondaryCalloutBody!,
                          accent: AppColors.primary,
                          background: AppColors.surfaceHighest,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              if (section.imageUrl != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(section.imageUrl!, fit: BoxFit.cover),
                        if (section.imageCaption != null)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              color: AppColors.surface.withValues(alpha: 0.78),
                              child: Text(
                                section.imageCaption!,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              if (section.bullets.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (final bullet in section.bullets) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bullet,
                          style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterCallout extends StatelessWidget {
  final String title;
  final String body;

  const _FooterCallout({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighest.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _CalloutBox extends StatelessWidget {
  final String title;
  final String body;
  final Color accent;
  final Color background;

  const _CalloutBox({
    required this.title,
    required this.body,
    required this.accent,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.labelCaps.copyWith(color: accent),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
