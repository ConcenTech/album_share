import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/providers/app_bar_listener.dart';
import '../../../services/providers/sidebar_listener.dart';
import '../app_window/desktop_window_titlebar.dart';
import '../sidebar/app_sidebar.dart';
import '../titlebar_buttons/titlebar_back_button.dart';

const _appBarHeight = 36.0;

class DesktopScaffold extends ConsumerWidget {
  const DesktopScaffold({
    required this.id,
    required this.showTitleBar,
    this.titleBarIcons = const [],
    this.header,
    this.showBackButton = false,
    required this.body,
    this.bottomNavigationBar,
    this.endDrawer,
    super.key,
  });

  /// A unique id for each page.
  final String id;

  /// Display the title, logo and menu icon.
  final bool showTitleBar;

  /// title bar icons will only be shown if showTitleBar is set to true.
  final List<Widget> titleBarIcons;

  final String? header;

  /// If [showTitleBar] and [showBackButton] are true, the back button
  /// will be shown on the title bar.
  final bool showBackButton;

  final Widget body;

  final Widget? bottomNavigationBar;

  final Widget? endDrawer;

  static double appBarHeight() => _appBarHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarVisible = ref.watch(appBarListenerProvider);
    final sidebarStatus = ref.watch(sidebarListenerProvider(id));

    void closeSidebar() =>
        ref.read(sidebarListenerProvider(id).notifier).close();

    return Scaffold(
      endDrawer: endDrawer,
      endDrawerEnableOpenDragGesture: false,
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
              opaque: true,
              child: SizedBox(
                height: _appBarHeight,
                child: DesktopWindowTitlebar(
                  showTitle: showTitleBar,
                  titleBarIcons: titleBarIcons,
                  leading: showBackButton ? const TitlebarBackButton() : null,
                  header: header,
                ),
              ),
            ),
          ),
          if (bottomNavigationBar != null)
            AnimatedPositioned(
              duration: kThemeAnimationDuration,
              left: 0,
              right: 0,
              bottom: appBarVisible ? 0 : -kBottomNavigationBarHeight,
              child: bottomNavigationBar!,
            ),
          if (endDrawer != null && sidebarStatus == SidebarStatus.open)
            Positioned(
              top: appBarVisible ? appBarHeight() : 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: closeSidebar,
                behavior: HitTestBehavior.translucent,
              ),
            ),
          if (endDrawer != null)
            AnimatedPositioned(
              duration: kThemeAnimationDuration,
              top: appBarVisible ? appBarHeight() : 0,
              bottom: 0,
              right: sidebarStatus.isOpen ? 0 : -AppSidebar.width,
              child: sidebarStatus.isClosed ? const SizedBox() : endDrawer!,
            ),
        ],
      ),
    );
  }
}
