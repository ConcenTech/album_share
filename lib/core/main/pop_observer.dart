import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class PopObserver extends NavigatorObserver {
  PopObserver({required this.onPop});
  final VoidCallback onPop;

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    SchedulerBinding.instance.addPostFrameCallback((_) => onPop());
  }
}
