import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/extension_methods.dart';

final appBarListenerProvider =
    StateNotifierProvider.autoDispose<AppBarListener, bool>(
  (ref) => AppBarListener(),
);

class AppBarListener extends StateNotifier<bool> {
  AppBarListener() : super(true);

  Timer? _timer;

  void show() => state = true;
  void hide() => state = false;

  void hideIn(Duration duration) {
    _timer = Timer(duration, () {
      if (mounted) {
        hide();
      }
    });
  }

  void showDelayed() {
    show();
    _timer = Timer(
      5.seconds,
      () {
        if (mounted) {
          hide();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
