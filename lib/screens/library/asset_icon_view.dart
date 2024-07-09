import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/asset.dart';
import '../../services/library/library_providers.dart';

class AssetIconView extends ConsumerWidget {
  const AssetIconView(this.asset, {super.key});

  final Asset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(LibraryProviders.assetPreview(asset)).maybeWhen(
          data: (data) => Image.memory(data),
          // TODO: Add a shimmer loading placeholder.
          orElse: () => CircularProgressIndicator(),
        );
  }
}
