import 'package:flutter/foundation.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'desktop_window_titlebar.dart';

const desktopPlatforms = [
  TargetPlatform.linux,
  TargetPlatform.macOS,
  TargetPlatform.windows,
];

abstract class AppWindow {
  static Future<void> setWindow(String title) async {
    if (desktopPlatforms.contains(defaultTargetPlatform)) {
      return DesktopWindowTitlebar.openWindow(title);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }
}
