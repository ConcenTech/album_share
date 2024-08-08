import 'package:flutter/material.dart';

import '../utils/app_localisations.dart';

class DialogButtons extends StatelessWidget {
  const DialogButtons({
    required this.onConfirm,
    this.onCancel,
    this.confirmText,
    this.cancelText,
    this.confirmStyle,
    this.cancelStyle,
    super.key,
  });

  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  final String? confirmText;
  final String? cancelText;

  final ButtonStyle? confirmStyle;
  final ButtonStyle? cancelStyle;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        onCancel == null
            ? const SizedBox()
            : OutlinedButton(
                onPressed: onCancel,
                style: cancelStyle,
                child: Text(cancelText ?? locale.cancel),
              ),
        FilledButton(
          onPressed: onConfirm,
          style: confirmStyle,
          child: Text(confirmText ?? locale.confirm),
        ),
      ],
    );
  }
}
