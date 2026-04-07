import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/features/prototype_viewer/models/prototype_screen.dart';
import 'package:smartify_flutter/features/prototype_viewer/widgets/prototype_png_screen.dart';
import 'package:smartify_flutter/features/screen-mapping/screen_manifest.dart';

class ScreenViewerScreen extends StatelessWidget {
  const ScreenViewerScreen({super.key, required this.screenId});

  final String screenId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ScreenManifestStore>();
    final items = store.items;
    final currentIndex = items.indexWhere((i) => i.id == screenId);
    final item = currentIndex >= 0 ? items[currentIndex] : null;

    if (store.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Manifest error')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(store.errorMessage ?? 'Không tải được dữ liệu màn hình.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => store.load(force: true),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (!store.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Screen not found')),
        body: Center(child: Text('Không tìm thấy màn #$screenId')),
      );
    }

    final screen = PrototypeScreen(
      id: item.id,
      order: currentIndex,
      assetPath: item.assetPath,
      route: item.route,
      feature: item.feature,
      label: item.label,
    );

    return PrototypePngScreen(
      screen: screen,
      hasPrev: currentIndex > 0,
      hasNext: currentIndex < items.length - 1,
      onPrev: () {
        final prev = items[currentIndex - 1];
        Navigator.pushReplacementNamed(context, prev.route);
      },
      onNext: () {
        final next = items[currentIndex + 1];
        Navigator.pushReplacementNamed(context, next.route);
      },
    );
  }
}
