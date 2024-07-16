import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/providers/app_bar_listener.dart';
import '../logo_widget.dart';
import '../titlebar_buttons/titlebar_back_button.dart';

class MobileScaffold extends ConsumerWidget {
  const MobileScaffold({
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

  static double appBarHeight(BuildContext context) =>
      kToolbarHeight + MediaQuery.of(context).padding.top;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarVisible = ref.watch(appBarListenerProvider);
    final appBarHeight = MobileScaffold.appBarHeight(context);

    return Scaffold(
      body: Stack(
        children: [
          body,
          if (showTitleBar)
            AnimatedPositioned(
              duration: kThemeAnimationDuration,
              left: 0,
              right: 0,
              top: appBarVisible ? 0 : -appBarHeight,
              child: Container(
                height: appBarHeight,
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: AppBar(
                  leading: showBackButton ? const TitlebarBackButton() : null,
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
                ),
              ),
            ),
        ],
      ),
    );
  }
}
