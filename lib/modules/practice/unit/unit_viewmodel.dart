import 'package:flutter/foundation.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/models/unit.dart';

class UnitViewModel extends ChangeNotifier {
  final RepoManager repoManager;
  final Unit unit;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  UnitViewModel({required this.repoManager, required this.unit}) {
    // fetchUnit();
  }

  // Future<void> fetchUnit() async {
  //   if (_isLoading) return;
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();
  //
  //   try {
  //     final jsonData = await repoManager.getUnitDetail(unitId);
  //     _unit =  Unit.fromMap(jsonData);
  //     if (_unit == null) _error = 'Không tìm thấy chủ đề.';
  //   } catch (e) {
  //     debugPrint("Error fetching unit $unitId: $e");
  //     _error = 'Không thể tải chủ đề. Hãy thử lại.';
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}