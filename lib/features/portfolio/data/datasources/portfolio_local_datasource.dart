import 'package:hive/hive.dart';

import '../models/project_model.dart';

/// Local data source for portfolio projects backed by a Hive box.
///
/// This class is the only place in the app that directly accesses Hive.
/// The box is expected to already be open when this class is used
/// (opened in `main.dart` during app initialisation).
class PortfolioLocalDatasource {
  static const String boxName = 'projects';

  Box<ProjectModel> get _box => Hive.box<ProjectModel>(boxName);

  /// Returns all [ProjectModel] objects currently stored in the box.
  List<ProjectModel> getProjects() => _box.values.toList();

  /// Persists [projects] to the box, replacing any existing data.
  Future<void> saveProjects(List<ProjectModel> projects) async {
    await _box.clear();
    for (final project in projects) {
      await _box.put(project.id, project);
    }
  }

  /// Returns `true` if the box contains no entries.
  bool get isEmpty => _box.isEmpty;
}
