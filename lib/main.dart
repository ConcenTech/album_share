import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import 'core/components/app_window/app_window.dart';
import 'core/main/app_lifecycle_scope.dart';
import 'core/main/locale_scope.dart';
import 'core/main/main_app.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.ensureInitialized();
  VideoPlayer.ensureInitialized();
  AppWindow.ensureInitialized();

  runApp(
    const ProviderScope(
      child: LocaleScope(
        child: AppLifecycleScope(
          child: MainApp(),
        ),
      ),
    ),
  );
//
}
