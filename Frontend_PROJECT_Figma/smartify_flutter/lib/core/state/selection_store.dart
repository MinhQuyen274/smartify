import 'package:flutter/foundation.dart';

class SelectionStore extends ChangeNotifier {
  String? _selectedHome;
  String? _selectedDevice;
  String? _selectedScene;

  String? get selectedHome => _selectedHome;
  String? get selectedDevice => _selectedDevice;
  String? get selectedScene => _selectedScene;

  void selectHome(String? value) {
    _selectedHome = value;
    notifyListeners();
  }

  void selectDevice(String? value) {
    _selectedDevice = value;
    notifyListeners();
  }

  void selectScene(String? value) {
    _selectedScene = value;
    notifyListeners();
  }
}
