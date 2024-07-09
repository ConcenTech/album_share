import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/preferences/preferences_providers.dart';

final hapticFeedbackProvider =
    StateNotifierProvider<HapticNotifier, void>((ref) {
  return HapticNotifier(ref);
});

class HapticNotifier extends StateNotifier<void> {
  void build() {}
  final Ref _ref;

  HapticNotifier(this._ref) : super(null);

  bool _hapticFeedbackEnabled() => _ref.read(PreferencesProviders.service).enableHapticFeedback;

  selectionClick() {
    if (_hapticFeedbackEnabled()) {
      HapticFeedback.selectionClick();
    }
  }

  lightImpact() {
    if (_hapticFeedbackEnabled()) {
      HapticFeedback.lightImpact();
    }
  }

  mediumImpact() {
    if (_hapticFeedbackEnabled()) {
      HapticFeedback.mediumImpact();
    }
  }

  heavyImpact() {
    if (_hapticFeedbackEnabled()) {
      HapticFeedback.heavyImpact();
    }
  }

  vibrate() {
    if (_hapticFeedbackEnabled()) {
      HapticFeedback.vibrate();
    }
  }
}
