import 'package:album_share/core/components/titlebar_buttons/titlebar_back_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'logo_widget.dart';
import 'window_titlebar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.showTitleBar,
    this.titleBarIcons = const [],
    this.showBackButton = false,
    required this.body,
    super.key,
  });

  /// Display the title, logo and menu icon.
  final bool showTitleBar;

  /// title bar icons will only be shown if showTitleBar is set to true.
  final List<Widget> titleBarIcons;

  /// If [showTitleBar] and [showBackButton] are true, the back button
  /// will be shown on the title bar.
  final bool showBackButton;

  final Widget body;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return Scaffold(
          appBar: showTitleBar
              ? AppBar(
                leading: showBackButton ? const TitlebarBackButton() : null ,
                  automaticallyImplyLeading: false,
                  actions: titleBarIcons,
                  title: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 25, child: LogoImage()),
                      SizedBox(width: 5),
                      LogoText(tagline: false),
                    ],
                  ),
                )
              : null,
          body: body,
        );
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return Scaffold(
          body: Column(
            children: [
              DesktopWindowTitlebar(
                showTitle: showTitleBar,
                titleBarIcons: titleBarIcons,
                leading: showBackButton ? const TitlebarBackButton() : null ,
              ),
              Expanded(child: body),
            ],
          ),
        );
    }
  }
}
