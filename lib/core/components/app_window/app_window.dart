import 'package:flutter/foundation.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'desktop_window_titlebar.dart';

const desktopPlatforms = [
  TargetPlatform.linux,
  TargetPlatform.macOS,
  TargetPlatform.windows,
];

abstract class AppWindow {
  static void setTitle(String title) {
    if (desktopPlatforms.contains(defaultTargetPlatform)) {
      DesktopWindowTitlebar.setTitle(title);
    }
  }

  static void setWindow() async {
    if (desktopPlatforms.contains(defaultTargetPlatform)) {
      return DesktopWindowTitlebar.openWindow();
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }
}
