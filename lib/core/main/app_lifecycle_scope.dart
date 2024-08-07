import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) => initWindow());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initWindow() {
    final locale = AppLocalizations.of(context);
    AppWindow.setWindow(locale?.appTitle ?? 'Album share')
        .then((_) => print('App window set'))
        .onError((e, _) => print('Failed to set window $e'));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
