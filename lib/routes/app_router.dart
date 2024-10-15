import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/album.dart';
import '../screens/album/album_screen.dart';
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
const _kAlbumRote = 'album';

class AppRouter {
  AppRouter(this._auth);

  final AuthService _auth;

  final key = GlobalKey();
  static final _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

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

  GoRouter routerConfig({List<NavigatorObserver>? observers}) => GoRouter(
        routes: routes,
        navigatorKey: _navigatorKey,
        restorationScopeId: 'router_config_scope',
        observers: observers,
      );

  final _assetViewerRoute = GoRoute(
    path: _kAssetViewerRoute,
    builder: (_, state) => AssetViewerScreen(
      viewerState: state.extra as AssetViewerScreenState,
    ),
  );

  final _preferencesRoute = GoRoute(
    path: _kPreferencesRoute,
    builder: (_, __) => const PreferencesScreen(),
  );

  late final _albumRoute = GoRoute(
      path: _kAlbumRote,
      builder: (_, state) => AlbumScreen(album: state.extra as Album),
      routes: [_assetViewerRoute, _preferencesRoute]);

  List<GoRoute> get routes => [
        GoRoute(
          path: _kLibraryRoute,
          builder: (_, __) => const LibraryScreen(),
          redirect: (_, __) => _authRedirect(true),
          routes: [
            _assetViewerRoute,
            _preferencesRoute,
            _albumRoute,
          ],
        ),
        GoRoute(
          path: _kLoginRoute,
          builder: (_, __) => const AuthScreen(),
          redirect: (_, __) => _authRedirect(false),
        ),
      ];

  static void to(String route, BuildContext? context, [Object? extra]) =>
      GoRouter.of(context ?? _navigatorKey.currentContext!)
          .push(route.startsWith('/') ? route : '/$route', extra: extra);

  static void back(BuildContext context) {
    try {
      Navigator.of(context).maybePop();
    } on GoError {
      // GoRouter throws on macOS when calling pop.
    }
  }

  static void toNotificationAssetViewer(AssetViewerScreenState viewerState) =>
      to(_kAssetViewerRoute, null, viewerState);
  static void toLibrary(BuildContext context) =>
      GoRouter.of(context).go(_kLibraryRoute);
  static void toPreferences(BuildContext context) =>
      to(_kPreferencesRoute, context);
  static void toLogin(BuildContext context) => to(_kLoginRoute, context);
  static void toAlbum(BuildContext context, Album album) =>
      to(_kAlbumRote, context, album);
  static void toAssetViewer(
    BuildContext context,
    AssetViewerScreenState viewerState,
  ) =>
      to(_kAssetViewerRoute, context, viewerState);
}
