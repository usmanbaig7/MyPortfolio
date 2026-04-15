import '../entities/project_entity.dart';

/// Abstract contract for the portfolio repository.
///
/// Defined in the domain layer so the domain remains independent of any
/// data-layer implementation (Hive, REST, etc.).  The data layer provides
/// the concrete implementation.
abstract class PortfolioRepository {
  /// Returns every [ProjectEntity] available from the data source.
  Future<List<ProjectEntity>> getProjects();
}
