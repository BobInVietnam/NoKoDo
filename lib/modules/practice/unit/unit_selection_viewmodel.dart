// item_grid_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/models/unit.dart';

class UnitSelectionViewModel extends ChangeNotifier {
  final RepoManager repoManager;
  List<Unit> _units = [];
  bool _loading = true;

  List<Unit> get units => _units;
  bool get loading => _loading;

  UnitSelectionViewModel({
    required this.repoManager
  }) {
    fetchUnits();
  }

  void fetchUnits() async {
    _loading = true;
    _units = await repoManager.getUnitList();
    debugPrint(_units.toString());
    _loading = false;
    notifyListeners();
  }
}