import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/project_entity.dart';

/// Card widget that displays a single [ProjectEntity] in the projects grid.
///
/// Supports a hover lift-and-glow effect on desktop via [MouseRegion].
/// Tapping the card navigates to `/project/:id` and passes the full entity
/// as `extra` so the detail screen never needs to re-fetch.
class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project});

  final ProjectEntity project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push(
          '/project/${widget.project.id}',
          extra: widget.project,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -8.0 : 0.0, 0),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusM),
            border: Border.all(
              color: _hovered
                  ? Color.fromRGBO(108, 99, 255, 0.55)
                  : AppColors.divider,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? Color.fromRGBO(108, 99, 255, 0.28)
                    : Colors.black26,
                blurRadius: _hovered ? 28 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoverImage(),
              Expanded(child: _buildContent(Theme.of(context))),
            ],
          ),
        ),
      ),
    );
  }

  // ── Cover image ────────────────────────────────────────────────────────────

  Widget _buildCoverImage() => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderRadiusM),
        ),
        child: Image.network(
          widget.project.imageUrl,
          height: AppSizes.projectImageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: AppSizes.projectImageHeight,
            color: AppColors.divider,
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.textSecondary,
              size: 40,
            ),
          ),
        ),
      );

  // ── Text content ───────────────────────────────────────────────────────────

  Widget _buildContent(ThemeData theme) => Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.project.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.project.shortDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            _buildTechChips(),
          ],
        ),
      );

  Widget _buildTechChips() => Wrap(
        spacing: 6,
        runSpacing: 4,
        children: widget.project.techStack
            .map(
              (tech) => Chip(
                label: Text(tech),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            )
            .toList(),
      );
}
