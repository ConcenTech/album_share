import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/providers/app_bar_listener.dart';
import '../titlebar_buttons/titlebar_back_button.dart';
import '../app_window/desktop_window_titlebar.dart';

const _appBarHeight = 36.0;

class DesktopScaffold extends ConsumerWidget {
  const DesktopScaffold({
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

  static double appBarHeight() => _appBarHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarVisible = ref.watch(appBarListenerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          body,
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            left: 0,
            right: 0,
            top: appBarVisible ? 0 : -_appBarHeight,
            child: MouseRegion(
              hitTestBehavior: HitTestBehavior.translucent,
              opaque: false,
              child: Container(
                height: _appBarHeight,
                color: (theme.appBarTheme.backgroundColor ??
                        theme.colorScheme.surface)
                    .withOpacity(0.6),
                child: DesktopWindowTitlebar(
                  showTitle: showTitleBar,
                  titleBarIcons: titleBarIcons,
                  leading: showBackButton ? const TitlebarBackButton() : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
