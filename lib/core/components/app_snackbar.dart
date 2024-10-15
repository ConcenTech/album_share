import 'package:album_share/core/components/scaffold/app_scaffold.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/app_localisations.dart';

class AppSnackbar {
  static Future<void> info({
    required BuildContext context,
    required String message,
    String? title,
    Widget? image,
    VoidCallback? onClick,
  }) {
    return _baseFlushbar(
      context: context,
      title: title,
      message: message,
      icon: image,
      onTap: onClick,
      color: Colors.blue,
      showExtended: false,
    );
  }

  static Future<void> success({
    required BuildContext context,
    required String message,
    Duration? duration,
    bool showExtended = false,
  }) {
    final color = Colors.green.shade300;
    return _baseFlushbar(
      context: context,
      title: AppLocalizations.of(context)!.success,
      message: message,
      icon: Icon(
        Icons.done,
        color: color,
      ),
      color: color,
      showExtended: showExtended,
    );
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

    return _baseFlushbar(
      context: context,
      title: error != null ? message : null,
      message: error ?? message,
      icon: Icon(
        Icons.warning,
        size: 28.0,
        color: color,
      ),
      color: color,
      showExtended: showExtended,
    );
  }

  static Future<dynamic> _baseFlushbar({
    required BuildContext context,
    required String? title,
    required String message,
    Widget? icon,
    Color? color,
    required bool showExtended,
    VoidCallback? onTap,
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
      margin: const EdgeInsets.all(8.0),
      positionOffset: AppScaffold.appBarHeight(context),
      titleSize: 12,
      messageSize: 10,
      onTap: onTap == null
          ? null
          : (bar) {
              onTap();
              bar.dismiss();
            },
    ).show(context);
  }
}
