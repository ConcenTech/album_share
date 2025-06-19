import 'package:flutter/material.dart';

import '../../utils/extension_methods.dart';
import '../scaffold/app_navigation_scaffold.dart';

const kBottomNavBarHeight = 80.0;

class MaterialBottomNavigationBar extends StatelessWidget {
  const MaterialBottomNavigationBar({
    required this.index,
    required this.items,
    required this.onDestinationSelected,
    super.key,
  });

  final int index;
  final void Function(int index) onDestinationSelected;
  final List<NavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).removePadding(removeTop: true),
      child: NavigationBar(
        backgroundColor:
            (theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface)
                .withValues(alpha: 0.6),
        selectedIndex: index,
        onDestinationSelected: onDestinationSelected,
        destinations: items.mapList(
          (e) => NavigationDestination(
            icon: e.icon,
            selectedIcon: e.selectedIcon,
            label: e.label,
          ),
        ),
      ),
    );
  }
}

class MaterialSideNavigationBar extends StatelessWidget {
  const MaterialSideNavigationBar({
    required this.index,
    required this.items,
    required this.onDestinationSelected,
    super.key,
  });

  final int index;
  final void Function(int index) onDestinationSelected;
  final List<NavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationRail(
      backgroundColor:
          (theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface)
              .withValues(alpha: 0.6),
      selectedIndex: index,
      onDestinationSelected: onDestinationSelected,
      destinations: items.mapList(
        (e) => NavigationRailDestination(
          icon: e.icon,
          selectedIcon: e.selectedIcon,
          label: Text(e.label),
        ),
      ),
      labelType: NavigationRailLabelType.all,
      useIndicator: true,
      groupAlignment: 0,
    );
  }
}
