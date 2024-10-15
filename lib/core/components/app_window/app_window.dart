import 'dart:async';

import 'package:album_share/core/utils/platform_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:window_manager/window_manager.dart';

const desktopPlatforms = [
  TargetPlatform.linux,
  TargetPlatform.macOS,
  TargetPlatform.windows,
];

abstract class AppWindow {
  static void ensureInitialized() {
    ifDesktop(() => unawaited(windowManager.ensureInitialized()));
  }

  static void setTitle(String title) {
    windowManager.setTitle(title);
  }

  static void openWindow(String title) async {
    final windowOptions = WindowOptions(
      minimumSize: const Size(300, 500),
      title: title,
      titleBarStyle: TitleBarStyle.hidden,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  static void maximiseOrRestore() async {
    if (await windowManager.isMaximized()) {
      await windowManager.unmaximize();
      return;
    }

    if (await windowManager.isMaximizable()) {
      await windowManager.maximize();
    }
  }

  static Future<void> setWindow(String title) async {
    if (desktopPlatforms.contains(defaultTargetPlatform)) {
      return openWindow(title);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }
}
