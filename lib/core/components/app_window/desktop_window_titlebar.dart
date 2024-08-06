import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../logo_widget.dart';
import 'app_window.dart';

class DesktopWindowTitlebar extends StatelessWidget {
  const DesktopWindowTitlebar({
    this.showTitle = true,
    this.leading,
    this.titleBarIcons = const [],
    super.key,
  });

  final Widget? leading;

  final List<Widget> titleBarIcons;

  static void setTitle(String title) {
    appWindow.title = title;
  }

  static void openWindow() {
    doWhenWindowReady(() {
      appWindow.title = 'Album share';
      appWindow.minSize = const Size(300, 500);
      appWindow.size = const Size(600, 500);
      appWindow.show();
    });
  }

  /// If true, displays the app logo and name in the top bar.
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    assert(desktopPlatforms.contains(defaultTargetPlatform));

    return WindowTitleBarBox(
      child: Row(
        children: [
          Expanded(
            child: MoveWindow(
              child: showTitle
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: SizedBox(
                            height: 16,
                            child: LogoImage(),
                          ),
                        ),
                        const SizedBox(width: 1),
                        if (leading != null) leading!,
                      ],
                    )
                  : null,
            ),
          ),
          ...titleBarIcons,
          MinimizeWindowButton(),
          MaximizeWindowButton(),
          CloseWindowButton(),
        ],
      ),
    );
  }
}
