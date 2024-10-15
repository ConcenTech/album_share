import 'package:flutter/material.dart';

import 'dialog_buttons.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    required this.child,
    this.confirmText,
    this.confirmStyle,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
    super.key,
  });

  final String title;
  final Widget child;

  final String? confirmText;
  final ButtonStyle? confirmStyle;
  final VoidCallback onConfirm;

  final String? cancelText;
  final VoidCallback? onCancel;

  static const EdgeInsetsGeometry contentPadding =
      EdgeInsets.fromLTRB(24, 12, 24, 16);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      contentPadding: contentPadding,
      children: [
        child,
        DialogButtons(
          onConfirm: onConfirm,
          onCancel: onCancel,
          confirmText: confirmText,
          confirmStyle: confirmStyle,
        ),
      ],
    );
  }
}
