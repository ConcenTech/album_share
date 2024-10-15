// ignore_for_file: avoid_print
// Logging framework likely not initialised at this point.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:logging/logging.dart';

import '../../services/logger/app_logger.dart';
import '../components/app_window/app_window.dart';
import '../utils/app_localisations.dart';

class AppLifecycleScope extends StatefulWidget {
  const AppLifecycleScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AppLifecycleScope> createState() => _AppLifecycleScopeState();
}

class _AppLifecycleScopeState extends State<AppLifecycleScope>
    with WidgetsBindingObserver {
  final logger = Logger('AppLifecycleScope');

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      _onClose();
    }
  }

  @override
  Future<AppExitResponse> didRequestAppExit() {
    _onClose();
    return super.didRequestAppExit();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      initWindow();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initWindow() {
    final locale = AppLocalizations.of(context)!;
    AppLocale.instance.set(locale);
    AppWindow.setWindow(locale.appTitle).then((_) {
      logger.info('App window set');
    }).onError((e, s) {
      print('Failed to set window: \n$e, \n$s');
      logger.severe('Failed to set window', e, s);
    });
  }

  void _onClose() {
    AppLogger.instance.flush();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
