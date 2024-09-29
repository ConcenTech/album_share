import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/providers/sidebar_listener.dart';

class ActivityButton extends ConsumerWidget {
  const ActivityButton(this.id, {super.key});

  /// The page id
  final String id;

  void _openOrClose(bool open, WidgetRef ref) {
    final notifier = ref.read(sidebarListenerProvider(id).notifier);
    return open ? notifier.open() : notifier.close();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(sidebarListenerProvider(id)).isOpen;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: () => print('Double tap button'),
      child: IconButton(
        icon: const Icon(Icons.message),
        onPressed: () => _openOrClose(!isOpen, ref),
        iconSize: 18,
        style: IconButton.styleFrom(
          minimumSize: const Size(25, 25),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
