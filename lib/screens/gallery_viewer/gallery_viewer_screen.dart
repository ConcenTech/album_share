import 'package:album_share/core/components/app_scaffold.dart';
import 'package:flutter/material.dart';

class GalleryViewerScreen extends StatelessWidget {
  const GalleryViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      showTitleBar: true,
      showBackButton: true,
      body: Placeholder(),
    );
  }
}
