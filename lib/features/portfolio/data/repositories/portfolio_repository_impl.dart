import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_datasource.dart';

/// Concrete implementation of [PortfolioRepository].
///
/// Bridges the domain and data layers by delegating to
/// [PortfolioLocalDatasource] and converting [ProjectModel] objects to
/// [ProjectEntity] objects before returning them to the domain.
class PortfolioRepositoryImpl implements PortfolioRepository {
  const PortfolioRepositoryImpl(this._localDatasource);

  final PortfolioLocalDatasource _localDatasource;

  @override
  Future<List<ProjectEntity>> getProjects() async {
    final models = _localDatasource.getProjects();
    return models.map((m) => m.toEntity()).toList();
  }
}
