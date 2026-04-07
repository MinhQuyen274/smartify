import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/screen-mapping/screen_manifest.dart';

class FeatureScreenList extends StatelessWidget {
  const FeatureScreenList({super.key, required this.items});

  final List<ScreenManifestItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text('#${item.id} ${item.label}'),
          subtitle: Text(item.route),
          trailing: const Icon(Icons.open_in_new_rounded),
          onTap: () => Navigator.pushNamed(context, item.route),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemCount: items.length,
    );
  }
}
