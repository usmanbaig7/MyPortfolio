import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../domain/entities/project_entity.dart';

/// Full-detail view for a single [ProjectEntity].
///
/// Receives the entity via GoRouter's `extra` parameter so no additional
/// data fetch is required.  Displays the cover image, full description,
/// tech-stack chips, and action buttons for live demo / GitHub.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final hPad = ResponsiveHelper.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Back',
          onPressed: () => context.pop(),
        ),
        title: Text(project.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroImage(imageUrl: project.imageUrl),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: AppSizes.paddingXL,
              ),
              child: _buildBody(context, isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          project.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: AppSizes.paddingL),

        // Full description
        Text(
          project.fullDescription,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.8,
              ),
        ),
        const SizedBox(height: AppSizes.paddingXL),

        // Tech stack
        _TechStackSection(techStack: project.techStack),
        const SizedBox(height: AppSizes.paddingXXL),

        // Action buttons
        _ActionButtons(
          liveUrl: project.liveUrl,
          githubUrl: project.githubUrl,
        ),
        const SizedBox(height: AppSizes.paddingXXL),
      ],
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────

/// Full-width cover image at the top of the detail screen.
class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: AppSizes.detailHeroHeight,
        width: double.infinity,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.cardBackground,
            child: const Icon(
              Icons.image_not_supported_outlined,
              size: 60,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
}

/// Labelled row of tech-stack chips.
class _TechStackSection extends StatelessWidget {
  const _TechStackSection({required this.techStack});

  final List<String> techStack;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.techStackLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: techStack.map((t) => Chip(label: Text(t))).toList(),
          ),
        ],
      );
}

/// Elevated + outlined CTA buttons for live demo and GitHub.
class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.liveUrl,
    required this.githubUrl,
  });

  final String liveUrl;
  final String githubUrl;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 16,
        runSpacing: 12,
        children: [
          if (liveUrl.isNotEmpty)
      
          if (githubUrl.isNotEmpty)
            OutlinedButton.icon(
              onPressed: () => _open(githubUrl),
              icon: const Icon(Icons.code_rounded, size: 18),
              label: const Text(AppStrings.githubSource),
            ),
        ],
      );
}
