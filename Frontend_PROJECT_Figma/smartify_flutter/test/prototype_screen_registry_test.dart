import 'package:flutter_test/flutter_test.dart';
import 'package:smartify_flutter/features/prototype_viewer/data/prototype_screen_registry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Registry loads with unique IDs and valid asset paths', () async {
    final screens = await PrototypeScreenRegistry.loadFromAssets();

    expect(screens, isNotEmpty);

    final idSet = <String>{};
    for (final screen in screens) {
      expect(screen.id, isNotEmpty);
      expect(screen.assetPath, startsWith('assets/png/'));
      expect(screen.assetPath, endsWith('.png'));
      expect(screen.route, '/screen/${screen.id}');
      expect(idSet.contains(screen.id), isFalse);
      idSet.add(screen.id);
    }
  });
}
