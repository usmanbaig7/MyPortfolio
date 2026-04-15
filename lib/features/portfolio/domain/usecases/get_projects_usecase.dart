import '../entities/project_entity.dart';
import '../repositories/portfolio_repository.dart';

/// Use case that retrieves all portfolio projects.
///
/// Encapsulates the single business-logic operation of fetching projects so
/// that the presentation layer does not depend directly on the repository.
class GetProjectsUsecase {
  const GetProjectsUsecase(this._repository);

  final PortfolioRepository _repository;

  /// Executes the use case and returns the list of [ProjectEntity] objects.
  Future<List<ProjectEntity>> call() => _repository.getProjects();
}
