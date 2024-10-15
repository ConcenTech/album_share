import 'package:flutter/material.dart';

import '../../../screens/auth/auth_listener.dart';
import '../../utils/platform_utils.dart';
import '../sidebar/app_sidebar.dart';
import 'desktop_scaffold.dart';
import 'mobile_scaffold.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.id,
    required this.showTitleBar,
    this.titleBarIcons = const [],
    this.header,
    this.showBackButton = false,
    required this.body,
    this.bottomNavigationBar,
    this.sidebar,
    this.isSplash = false,
    super.key,
  });

  /// A unique id for each page.
  final String id;

  /// Display the title, logo and menu icon.
  final bool showTitleBar;

  /// title bar icons will only be shown if showTitleBar is set to true.
  final List<Widget> titleBarIcons;

  /// A replacement for the app title.
  final String? header;

  /// If [showTitleBar] and [showBackButton] are true, the back button
  /// will be shown on the title bar.
  final bool showBackButton;

  final Widget body;

  final Widget? bottomNavigationBar;

  final AppSidebar? sidebar;

  final bool isSplash;

  @override
  Widget build(BuildContext context) {
    final child = isSplash ? body : AuthListener(child: body);
    return forPlatform(
      desktop: () {
        return DesktopScaffold(
          id: id,
          showTitleBar: showTitleBar,
          titleBarIcons: titleBarIcons,
          showBackButton: showBackButton,
          body: child,
          bottomNavigationBar: bottomNavigationBar,
          header: header,
          endDrawer: sidebar,
        );
      },
      mobile: () {
        return MobileScaffold(
          id: id,
          showTitleBar: showTitleBar,
          titleBarIcons: titleBarIcons,
          showBackButton: showBackButton,
          body: child,
          bottomNavigationBar: bottomNavigationBar,
          header: header,
          endDrawer: sidebar,
        );
      },
    );
  }

  static double appBarHeight(BuildContext context) {
    return forPlatform(
      desktop: () => DesktopScaffold.appBarHeight(),
      mobile: () => MobileScaffold.appBarHeight(context),
    );
  }
}
