/// Pure domain entity representing a portfolio project.
///
/// This class has no dependencies on any framework or library — it is a
/// plain Dart class that lives entirely in the domain layer.
class ProjectEntity {
  const ProjectEntity({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.techStack,
    required this.imageUrl,
    required this.liveUrl,
    required this.githubUrl,
  });

  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final List<String> techStack;

  /// URL to a representative screenshot or cover image.
  final String imageUrl;

  /// URL to the hosted live demo (may be empty).
  final String liveUrl;

  /// URL to the GitHub repository (may be empty).
  final String githubUrl;
}
