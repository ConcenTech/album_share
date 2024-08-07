import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/app_localisations.dart';

class AppSnackbar {
  static Future<void> success({
    required BuildContext context,
    required String message,
    Duration? duration,
    bool showExtended = false,
  }) {
    final color = Colors.green.shade300;
    return _baseFlushbar(
      title: AppLocalizations.of(context)!.success,
      message: message,
      icon: Icon(
        Icons.done,
        color: color,
      ),
      color: color,
      showExtended: showExtended,
    ).show(context);
  }

  static Future<void> warning({
    required BuildContext context,
    required String message,
    String? error,
    bool showExtended = false,
  }) async {
    if (kDebugMode && error != null) {
      // ignore: avoid_print
      print(error);
    }

    final color = Colors.red.shade300;

    await _baseFlushbar(
      title: error != null ? message : null,
      message: error ?? message,
      icon: Icon(
        Icons.warning,
        size: 28.0,
        color: color,
      ),
      color: color,
      showExtended: showExtended,
    ).show(context);
  }

  static Flushbar _baseFlushbar({
    required String? title,
    required String message,
    required Icon icon,
    required Color color,
    required bool showExtended,
  }) {
    return Flushbar(
      title: title,
      message: message,
      icon: icon,
      leftBarIndicatorColor: color,
      duration: Duration(seconds: showExtended ? 10 : 5),
      flushbarStyle: FlushbarStyle.FLOATING,
      maxWidth: 1000,
      borderRadius: BorderRadius.circular(10),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
    );
  }
}
