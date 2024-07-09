import 'package:album_share/services/library/library_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../models/asset_group.dart';

class LibraryWidget extends StatefulWidget {
  const LibraryWidget({super.key});

  @override
  State<LibraryWidget> createState() => _LibraryWidgetState();
}

class _LibraryWidgetState extends State<LibraryWidget> {
  final List<AssetGroup> assetGroups = [];

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: assetGroups.length,
      itemBuilder: (context, index) {
        return Placeholder();
      },
    );
  }
}

class _SectionBuilder extends ConsumerWidget {
  const _SectionBuilder(this.group, {super.key});

  final AssetGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(LibraryProviders.groupedAssets(group)).maybeWhen(
      data: (assets) {
        return GridView.builder(
          itemCount: assets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemBuilder: (context, index) {},
        );
      },
      orElse: () {
        return _SectionPlaceholder(group.length);
      },
    );
  }
}

class _SectionPlaceholder extends StatelessWidget {
  const _SectionPlaceholder(this.imageCount, {super.key});

  final int imageCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: imageCount,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, _) => const Placeholder(),
    );
  }
}
