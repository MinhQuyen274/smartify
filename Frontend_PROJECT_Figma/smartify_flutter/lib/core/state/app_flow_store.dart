import 'package:flutter/foundation.dart';

class AppFlowStore extends ChangeNotifier {
  String _activeFeature = 'home';

  String get activeFeature => _activeFeature;

  void setActiveFeature(String feature) {
    if (_activeFeature == feature) {
      return;
    }
    _activeFeature = feature;
    notifyListeners();
  }
}
