import 'package:flutter/material.dart';

import '../navigation_bar/cupertino_navigation_bar.dart';
import '../navigation_bar/material_navigation_bar.dart';
import '../sidebar/app_sidebar.dart';
import 'app_scaffold.dart';

const _kSizeForSideAppBar = 500;
const kSideAppBarMinWidth = 72.0;

class AppNavigationScaffold extends StatefulWidget {
  const AppNavigationScaffold({
    required this.id,
    required this.screens,
    this.titleBarIcons = const [],
    this.showBackButton = true,
    this.sidebar,
    super.key,
  });

  /// A unique id for each page.
  final String id;

  final List<NavigationBarItem> screens;

  final List<Widget> titleBarIcons;

  final bool showBackButton;

  final AppSidebar? sidebar;

  @override
  State<AppNavigationScaffold> createState() => _AppNavigationScaffoldState();
}

class _AppNavigationScaffoldState extends State<AppNavigationScaffold> {
  final _pageController = PageController();

  int _index = 0;

  void _updateIndex(int index) {
    if (mounted) {
      setState(() {
        _index = index;
      });
      _pageController.animateToPage(
        index,
        duration: kThemeAnimationDuration,
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? bottomNavigationBar;
    Widget? sideNavigationBar;

    MaterialBottomNavigationBar materialBottomNavBar() =>
        MaterialBottomNavigationBar(
          index: _index,
          onDestinationSelected: _updateIndex,
          items: widget.screens,
        );
    MaterialSideNavigationBar materialSideNavBar() => //
        MaterialSideNavigationBar(
          index: _index,
          onDestinationSelected: _updateIndex,
          items: widget.screens,
        );
    CupertinoBottomNavigationBar cupertinoBottomNavBar() =>
        CupertinoBottomNavigationBar(
          index: _index,
          onDestinationSelected: _updateIndex,
          items: widget.screens,
        );

    final platform = Theme.of(context).platform;
    switch (platform) {
      case TargetPlatform.fuchsia:
        throw UnimplementedError('Platform not currently supported');
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        sideNavigationBar = materialSideNavBar();
        break;
      case TargetPlatform.android:
        final size = MediaQuery.sizeOf(context);
        if (size.width >= _kSizeForSideAppBar) {
          sideNavigationBar = materialSideNavBar();
        } else {
          bottomNavigationBar = materialBottomNavBar();
        }
        break;
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        bottomNavigationBar = cupertinoBottomNavBar();
        break;
    }

    // final body = widget.screens[_index].builder(context);
    final screenHeight = MediaQuery.sizeOf(context).height;

    final body = PageView.builder(
      controller: _pageController,
      allowImplicitScrolling: false,
      // physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (value) {
        setState(() {
          _index = value;
        });
      },
      itemCount: widget.screens.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: screenHeight,
          child: widget.screens[index].builder(context),
        );
      },
    );

    return AppScaffold(
      id: widget.id,
      showTitleBar: true,
      titleBarIcons: widget.titleBarIcons,
      showBackButton: widget.showBackButton,
      bottomNavigationBar: bottomNavigationBar,
      sidebar: widget.sidebar,
      body: sideNavigationBar == null
          ? body
          : Row(
              children: [
                SizedBox(width: kSideAppBarMinWidth, child: sideNavigationBar),
                Expanded(child: body)
              ],
            ),
    );
  }
}

class NavigationBarItem {
  final Widget Function(BuildContext context) builder;
  final Widget icon;
  final Widget? selectedIcon;
  final String label;

  const NavigationBarItem({
    required this.builder,
    required this.icon,
    this.selectedIcon,
    required this.label,
  });
}
