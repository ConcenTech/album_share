import 'package:album_share/screens/preferences/preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../immich/asset_grid/asset_grid_data_structure.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/library/library_screen.dart';
import '../services/auth/auth_service.dart';

const _kLibraryRoute = '/';
const _kLoginRoute = '/login';
const _kPreferencesRoute = '/preferences';

class AppRouter {
  AppRouter(this._auth);

  final AuthService _auth;

  final vRouterKey = GlobalKey<VRouterState>();

  Future<void> _authGuard(VRedirector vRedirector,
      [bool authRequired = true]) async {
    final authenticated = await _auth.checkAuthStatus();

    if (authenticated && !authRequired) {
      return vRedirector.to(_kLibraryRoute, isReplacement: true);
    }

    if (!authenticated && authRequired) {
      return vRedirector.to(_kLoginRoute, isReplacement: true);
    }
  }

  String get initialRoute => _kLibraryRoute;

  List<VRouteElement> get routes => [
        VGuard(
          beforeEnter: (vRedirector) => _authGuard(vRedirector),
          stackedRoutes: [
            VWidget(
              path: _kLibraryRoute,
              widget: const LibraryScreen(),
            ),
            VWidget(
              path: _kPreferencesRoute,
              widget: const PreferencesScreen(),
            ),
          ],
        ),
        VGuard(
          beforeEnter: (vRedirector) => _authGuard(vRedirector, false),
          stackedRoutes: [
            VWidget(
              path: _kLoginRoute,
              widget: const AuthScreen(),
            ),
          ],
        ),
      ];

  static void to(String route, BuildContext context) =>
      VRouter.of(context).to(route);

  static void back(BuildContext context) {
    final router = VRouter.of(context);
    if (router.historyCanBack()) {
      router.historyBack();
    }
  }

  static void toLibrary(BuildContext context) => to(_kLibraryRoute, context);
  static void toPreferences(BuildContext context) =>
      to(_kPreferencesRoute, context);
  static void toLogin(BuildContext context) => to(_kLoginRoute, context);

  static void toGalleryViewer(
    BuildContext context, {
    required RenderList renderList,
    int initialIndex = 0,
    int heroOffset = 0,
    bool showStack = false,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return Placeholder();
        }),
      );
}
