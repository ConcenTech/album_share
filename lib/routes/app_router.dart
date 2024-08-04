import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/asset_viewer/asset_viewer_screen.dart';
import '../screens/asset_viewer/asset_viewer_screen_state.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/preferences/preferences_screen.dart';
import '../services/auth/auth_service.dart';

const _kLibraryRoute = '/';
const _kLoginRoute = '/login';
const _kPreferencesRoute = 'preferences';
const _kAssetViewerRoute = 'assets';

final router = GoRouter(
  routes: [],
);

class AppRouter {
  AppRouter(this._auth);

  final AuthService _auth;

  final key = GlobalKey();
  final navigatorKey = GlobalKey<NavigatorState>();

  Future<String?> _authRedirect(bool authRequired) async {
    final authenticated = await _auth.checkAuthStatus();

    if (authenticated && !authRequired) {
      return _kLibraryRoute;
    }

    if (!authenticated && authRequired) {
      return _kLoginRoute;
    }

    return null;
  }

  GoRouter get routerConfig => GoRouter(
        routes: routes,
        debugLogDiagnostics: true,
        navigatorKey: navigatorKey,
      );

  List<GoRoute> get routes => [
        GoRoute(
          path: _kLibraryRoute,
          builder: (_, __) => const LibraryScreen(),
          redirect: (_, __) => _authRedirect(true),
          routes: [
            GoRoute(
              path: _kPreferencesRoute,
              builder: (_, __) => const PreferencesScreen(),
              redirect: (_, __) => _authRedirect(true),
            ),
            GoRoute(
              path: _kAssetViewerRoute,
              builder: (_, state) => AssetViewerScreen(
                viewerState:
                    AssetViewerScreenState.fromExtra(state.extra ?? {}),
              ),
              redirect: (_, __) => _authRedirect(true),
            ),
          ],
        ),
        GoRoute(
          path: _kLoginRoute,
          builder: (_, __) => const AuthScreen(),
          redirect: (_, __) => _authRedirect(false),
        ),
      ];

  static void to(String route, BuildContext context) =>
      GoRouter.of(context).go(route.startsWith('/') ? route : '/$route');

  static void back(BuildContext context) => GoRouter.of(context).pop();

  static void toLibrary(BuildContext context) => to(_kLibraryRoute, context);
  static void toPreferences(BuildContext context) =>
      to(_kPreferencesRoute, context);
  static void toLogin(BuildContext context) => to(_kLoginRoute, context);
  static void toAssetViewer(
    BuildContext context,
    AssetViewerScreenState viewerState,
  ) =>
      GoRouter.of(context).go(
        '/$_kAssetViewerRoute',
        extra: viewerState.toExtra(),
      );
}
