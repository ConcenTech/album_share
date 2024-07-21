import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/extension_methods.dart';

final appBarListenerProvider =
    StateNotifierProvider.autoDispose<AppBarListener, bool>(
  (ref) => AppBarListener(),
);

class AppBarListener extends StateNotifier<bool> {
  AppBarListener() : super(true);

  Timer? _timer;

  void show([bool statusBar = false]) {
    _timer?.cancel();
    state = true;
    _maybeToggleStatusBar(true, statusBar);
  }

  void hide([bool statusBar = false]) {
    _timer?.cancel();
    state = false;
    _maybeToggleStatusBar(false, statusBar);
  }

  void hideIn(Duration duration, [bool statusBar = false]) {
    _timer = Timer(duration, () {
      if (mounted) {
        hide();
        _maybeToggleStatusBar(false, statusBar);
      }
    });
  }

  void showDelayed([bool statusBar = false]) {
    show();
    _maybeToggleStatusBar(true, statusBar);
    _timer = Timer(
      5.seconds,
      () {
        if (mounted) {
          hide();
          _maybeToggleStatusBar(false, statusBar);
        }
      },
    );
  }

  void _maybeToggleStatusBar(bool show, bool statusBar) {
    if (!statusBar) {
      return;
    }

    if (show) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    }
  }

  void toggle([bool statusBar = true]) {
    _timer?.cancel();
    state = !state;
    _maybeToggleStatusBar(state, statusBar);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
