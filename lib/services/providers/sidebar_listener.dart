import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sidebarListenerProvider = StateNotifierProvider.autoDispose
    .family<SidebarListener, SidebarStatus, String>(
  (ref, _) => SidebarListener(),
);

class SidebarListener extends StateNotifier<SidebarStatus> {
  SidebarListener() : super(SidebarStatus.closed);

  Timer? _timer;

  void open() {
    _timer?.cancel();
    state = SidebarStatus.open;
  }

  void close() async {
    state = SidebarStatus.closing;
    _timer = Timer(kThemeAnimationDuration, () {
      if (mounted) {
        state = SidebarStatus.closed;
      }
    });
  }
}

enum SidebarStatus {
  open,
  closing,
  closed,
  ;

  bool get isOpen => this == SidebarStatus.open;
  bool get isClosing => this == SidebarStatus.closing;
  bool get isClosed => this == SidebarStatus.closed;
}
