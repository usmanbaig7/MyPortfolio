import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/animated_fade_in.dart';
import '../../../../core/widgets/section_title.dart';
import '../providers/portfolio_provider.dart';
import 'project_card.dart';

/// Displays the Projects section heading and a responsive [GridView] of
/// [ProjectCard] widgets populated from [PortfolioProvider].
///
/// The grid automatically adjusts its column count based on screen width:
/// desktop → 3, tablet → 2, mobile → 1.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final hPad = ResponsiveHelper.horizontalPadding(context);
    final crossAxisCount = ResponsiveHelper.gridCrossAxisCount(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppSizes.paddingXXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnimatedFadeIn(
            child: SectionTitle(
              title: AppStrings.sectionProjects,
              subtitle: AppStrings.projectsSubtitle,
            ),
          ),
          const SizedBox(height: 40),
          Consumer<PortfolioProvider>(
            builder: (context, provider, _) =>
                _buildContent(provider, crossAxisCount, isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    PortfolioProvider provider,
    int crossAxisCount,
    bool isMobile,
  ) {
    switch (provider.status) {
      case PortfolioStatus.initial:
      case PortfolioStatus.loading:
        return const _LoadingIndicator();

      case PortfolioStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXXL),
            child: Text(
              'Could not load projects:\n${provider.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        );

      case PortfolioStatus.loaded:
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSizes.paddingL,
            mainAxisSpacing: AppSizes.paddingL,
            // Taller cards on single-column layout for readability
            childAspectRatio: crossAxisCount == 1 ? 1.1 : 1.4,
          ),
          itemCount: provider.projects.length,
          itemBuilder: (context, i) => AnimatedFadeIn(
            delay: Duration(milliseconds: 80 * i),
            child: ProjectCard(project: provider.projects[i]),
          ),
        );
    }
  }
}

/// Centered loading spinner shown while projects are being fetched.
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingXXL),
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      );
}
