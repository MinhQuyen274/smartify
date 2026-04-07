import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:smartify_flutter/features/prototype_viewer/models/prototype_screen.dart';
import 'package:smartify_flutter/features/prototype_viewer/utils/asset_name_parser.dart';

class PrototypeScreenRegistry {
  const PrototypeScreenRegistry._();

  static Future<List<PrototypeScreen>> loadFromAssets() async {
    final raw = await rootBundle.loadString('AssetManifest.json');
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final paths = decoded.keys
        .where((k) => k.startsWith('assets/png/') && k.endsWith('.png'))
        .toList()
      ..sort((a, b) {
        final af = a.split('/').last;
        final bf = b.split('/').last;
        return AssetNameParser.parseOrder(af).compareTo(AssetNameParser.parseOrder(bf));
      });

    return paths.map((assetPath) {
      final fileName = assetPath.split('/').last;
      final normalized = fileName.replaceAll('.png', '');
      final id = AssetNameParser.parseId(fileName);
      return PrototypeScreen(
        id: id,
        order: AssetNameParser.parseOrder(fileName),
        assetPath: assetPath,
        route: '/screen/$id',
        feature: AssetNameParser.resolveFeature(normalized),
        label: AssetNameParser.parseLabel(fileName),
      );
    }).toList();
  }
}
