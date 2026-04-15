import 'package:flutter/foundation.dart';

import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/get_projects_usecase.dart';

/// Possible loading states for the portfolio feature.
enum PortfolioStatus { initial, loading, loaded, error }

/// Presentation-layer state manager for the portfolio feature.
///
/// Uses [ChangeNotifier] so that [Consumer] widgets rebuild automatically
/// whenever the project list or loading state changes.
/// Depends on [GetProjectsUsecase] which it receives via constructor injection.
class PortfolioProvider extends ChangeNotifier {
  PortfolioProvider(this._getProjectsUsecase);

  final GetProjectsUsecase _getProjectsUsecase;

  PortfolioStatus _status = PortfolioStatus.initial;
  List<ProjectEntity> _projects = [];
  String _errorMessage = '';

  PortfolioStatus get status => _status;
  List<ProjectEntity> get projects => List.unmodifiable(_projects);
  String get errorMessage => _errorMessage;

  /// Fetches all projects via the use case and updates state accordingly.
  Future<void> fetchProjects() async {
    if (_status == PortfolioStatus.loading) return; // prevent duplicate calls

    _status = PortfolioStatus.loading;
    notifyListeners();

    try {
      _projects = await _getProjectsUsecase();
      _status = PortfolioStatus.loaded;
    } catch (e, stackTrace) {
      debugPrint('PortfolioProvider.fetchProjects error: $e\n$stackTrace');
      _errorMessage = e.toString();
      _status = PortfolioStatus.error;
    }

    notifyListeners();
  }
}
