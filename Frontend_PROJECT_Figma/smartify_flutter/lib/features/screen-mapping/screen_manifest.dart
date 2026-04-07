import 'package:flutter/foundation.dart';
import 'package:smartify_flutter/features/prototype_viewer/data/prototype_screen_registry.dart';
import 'package:smartify_flutter/features/prototype_viewer/models/prototype_screen.dart';

class ScreenManifestItem {
  const ScreenManifestItem({
    required this.id,
    required this.assetPath,
    required this.route,
    required this.feature,
    required this.label,
  });

  final String id;
  final String assetPath;
  final String route;
  final String feature;
  final String label;
}

class ScreenManifestStore extends ChangeNotifier {
  final List<ScreenManifestItem> _items = [];
  bool _isLoaded = false;
  String? _errorMessage;

  List<ScreenManifestItem> get items => List.unmodifiable(_items);
  bool get isLoaded => _isLoaded;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  Future<void> load({bool force = false}) async {
    if (_isLoaded && !force) {
      return;
    }
    try {
      final screens = await PrototypeScreenRegistry.loadFromAssets();

      _items
        ..clear()
        ..addAll(screens.map(_mapPrototypeToItem));
      _isLoaded = true;
      _errorMessage = null;
    } catch (error) {
      _isLoaded = false;
      _errorMessage = 'Không tải được screen manifest.';
    }
    notifyListeners();
  }

  ScreenManifestItem? byRoute(String route) {
    for (final item in _items) {
      if (item.route == route) {
        return item;
      }
    }
    return null;
  }

  List<ScreenManifestItem> byFeature(String feature) {
    return _items.where((item) => item.feature == feature).toList();
  }

  ScreenManifestItem _mapPrototypeToItem(PrototypeScreen screen) {
    return ScreenManifestItem(
      id: screen.id,
      assetPath: screen.assetPath,
      route: screen.route,
      feature: screen.feature,
      label: screen.label,
    );
  }
}
