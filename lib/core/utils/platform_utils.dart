import 'package:flutter/foundation.dart';

bool isCupertino = defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS;

T forPlatform<T>({
  required T Function() desktop,
  required T Function() mobile,
}) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.fuchsia:
      return mobile();
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      return desktop();
  }
}

void ifDesktop(VoidCallback callback) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      return callback();
    default:
  }
}

void ifMobile(VoidCallback callback) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.fuchsia:
      return callback();
    default:
  }
}

T? platformValue<T>({
  required T? desktop,
  required T? mobile,
}) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.fuchsia:
      return mobile;
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      return desktop;
  }
}
