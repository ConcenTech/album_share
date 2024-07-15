import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../screens/asset_viewer/asset_viewer_screen.dart';
import '../screens/asset_viewer/asset_viewer_screen_state.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/preferences/preferences_screen.dart';
import '../services/auth/auth_service.dart';

const _kLibraryRoute = '/';
const _kLoginRoute = '/login';
const _kPreferencesRoute = '/preferences';
const _kAssetViewerRoute = '/assets';

class AppRouter {
  AppRouter(this._auth);

  final AuthService _auth;

  final vRouterKey = GlobalKey<VRouterState>();

  Future<void> _authGuard(
    VRedirector vRedirector, [
    bool authRequired = true,
  ]) async {
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
              stackedRoutes: [
                VWidget(
                  path: _kPreferencesRoute,
                  widget: const PreferencesScreen(),
                ),
                VWidget(
                  path: _kAssetViewerRoute,
                  widget: const AssetViewerScreen(),
                )
              ],
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

  static void to(String route, BuildContext context,
          [Map<String, String> queryParameters = const {}]) =>
      VRouter.of(context).to(route, queryParameters: queryParameters);

  static void back(BuildContext context) => VRouter.of(context).pop();

  static void toLibrary(BuildContext context) => to(_kLibraryRoute, context);
  static void toPreferences(BuildContext context) =>
      to(_kPreferencesRoute, context);
  static void toLogin(BuildContext context) => to(_kLoginRoute, context);
  static void toAssetViewer(
    BuildContext context,
    AssetViewerScreenState routeState,
  ) =>
      to(_kAssetViewerRoute, context, routeState.toQuery());
}
