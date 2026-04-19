import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

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

        // Demo video
        if (project.youtubeVideoId != null &&
            project.youtubeVideoId!.isNotEmpty)
          _DemoVideoSection(
            videoId: project.youtubeVideoId!,
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

// ── YouTube demo video section ───────────────────────────────────────────

/// Tracks which view types have already been registered with the platform
/// view registry (registration must happen exactly once per type).
final _registeredYtViewTypes = <String>{};

/// Inline 16:9 YouTube video embedded directly on the detail page.
class _DemoVideoSection extends StatefulWidget {
  const _DemoVideoSection({required this.videoId});

  final String videoId;

  @override
  State<_DemoVideoSection> createState() => _DemoVideoSectionState();
}

class _DemoVideoSectionState extends State<_DemoVideoSection> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'yt-inline-${widget.videoId}';

    if (!_registeredYtViewTypes.contains(_viewType)) {
      _registeredYtViewTypes.add(_viewType);
      ui_web.platformViewRegistry.registerViewFactory(
        _viewType,
        (int viewId) {
          final origin = Uri.encodeComponent(
            html.window.location.origin,
          );
          final embedUrl =
              'https://www.youtube.com/embed/${widget.videoId}'
              '?rel=0&modestbranding=1&enablejsapi=1&origin=$origin';
          return html.IFrameElement()
            ..src = embedUrl
            ..allowFullscreen = true
            ..setAttribute(
              'allow',
              'accelerometer; autoplay; clipboard-write; '
                  'encrypted-media; gyroscope; picture-in-picture',
            )
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%';
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.demoVideoLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: HtmlElementView(viewType: _viewType),
            ),
          ),
        ),
      ],
    );
  }
}
