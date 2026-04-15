import 'package:hive/hive.dart';

import '../../domain/entities/project_entity.dart';

part 'project_model.g.dart';

/// Data model for a portfolio project stored in Hive.
///
/// Annotated with [HiveType] and [HiveField] so that `build_runner` can
/// generate the [ProjectModelAdapter] in `project_model.g.dart`.
/// Use [toEntity] to convert to the domain layer representation.
@HiveType(typeId: 0)
class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.techStack,
    required this.imageUrl,
    required this.liveUrl,
    required this.githubUrl,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String shortDescription;

  @HiveField(3)
  final String fullDescription;

  @HiveField(4)
  final List<String> techStack;

  @HiveField(5)
  final String imageUrl;

  @HiveField(6)
  final String liveUrl;

  @HiveField(7)
  final String githubUrl;

  /// Converts this Hive model to a pure domain [ProjectEntity].
  ProjectEntity toEntity() => ProjectEntity(
        id: id,
        title: title,
        shortDescription: shortDescription,
        fullDescription: fullDescription,
        techStack: List<String>.from(techStack),
        imageUrl: imageUrl,
        liveUrl: liveUrl,
        githubUrl: githubUrl,
      );

  /// Creates a [ProjectModel] from a domain [ProjectEntity].
  factory ProjectModel.fromEntity(ProjectEntity entity) => ProjectModel(
        id: entity.id,
        title: entity.title,
        shortDescription: entity.shortDescription,
        fullDescription: entity.fullDescription,
        techStack: List<String>.from(entity.techStack),
        imageUrl: entity.imageUrl,
        liveUrl: entity.liveUrl,
        githubUrl: entity.githubUrl,
      );
}
