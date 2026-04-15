import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/animated_fade_in.dart';

/// The hero / landing section of the portfolio page.
///
/// Desktop layout: Row(text content | profile image).
/// Mobile layout : Column(profile image | text content).
///
/// The profile image has an animated glowing border powered by an
/// [AnimationController] that pulses between opacities.
class HeroSection extends StatefulWidget {
  const HeroSection({super.key, required this.onViewProjects});

  /// Callback invoked when the user taps "View Projects".
  final VoidCallback onViewProjects;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final hPad = ResponsiveHelper.horizontalPadding(context);

    return Container(
      height: 600,
      constraints:BoxConstraints(minHeight: screenHeight * AppSizes.heroMinHeightFraction),
      padding: EdgeInsets.fromLTRB(90, 90, 90, 90),
      child: isMobile ? _mobileLayout() : _desktopLayout(),
    );
  }

  Widget _desktopLayout() => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 55, child: _textContent()),
          const SizedBox(width: 48),
          Expanded(flex: 55, child: _profileImage()),
        ],
      );

  Widget _mobileLayout() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _profileImage(),
          const SizedBox(height: 24),
          _textContent(),
        ],
      );

  // ── Text content ───────────────────────────────────────────────────────────

  Widget _textContent() {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final align = isMobile ? TextAlign.center : TextAlign.start;
    final crossAxis = isMobile
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final wrapAlign =
        isMobile ? WrapAlignment.center : WrapAlignment.start;

    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossAxis,
        children: [
          Text(
            AppStrings.heroName,
            textAlign: align,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.heroDesignation,
            textAlign: align,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.heroTagline,
            textAlign: align,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: wrapAlign,
            spacing: 16,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: widget.onViewProjects,
                icon: const Icon(Icons.grid_view_rounded, size: 18),
                label: const Text(AppStrings.ctaViewProjects),
              ),
              OutlinedButton.icon(
                onPressed: _launchContact,
                icon: const Icon(Icons.mail_outline_rounded, size: 18),
                label: const Text(AppStrings.ctaContact),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchContact() async {
    final uri = Uri.parse(AppStrings.contactEmail);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  // ── Profile image ──────────────────────────────────────────────────────────

  Widget _profileImage() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final size = isMobile
        ? AppSizes.profileImageSizeMobile
        : AppSizes.profileImageSize;
    const borderWidth = 3.0;

    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 300),
      child: Center(
        child: AnimatedBuilder(
          animation: _glowAnim,
          builder: (context, child) {
            final glow = _glowAnim.value;
            return Container(
              width: size + borderWidth * 2,
              height: size + borderWidth * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(108, 99, 255, glow * 0.45),
                    blurRadius: 48,
                    spreadRadius: 8,
                  ),
                ],
                gradient: SweepGradient(
                  colors: [
                    Color.fromRGBO(108, 99, 255, glow),
                    Color.fromRGBO(157, 151, 255, 0.4),
                    Color.fromRGBO(108, 99, 255, glow),
                  ],
                  transform: GradientRotation(
                    _glowController.value * 2 * math.pi,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(borderWidth),
              child: child!,
            );
          },
          child: ClipOval(
            child: Image.network(
              AppStrings.profileImageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: size,
                height: size,
                color: AppColors.cardBackground,
                child: Icon(
                  Icons.person,
                  size: size * 0.4,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
