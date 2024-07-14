import 'package:flutter/material.dart';

import 'dialog_buttons.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  String? message,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => _ConfirmationDialog(message: message),
      ) ??
      false;
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({
    required this.message,
  });

  final String? message;

  void _confirm(BuildContext context) => Navigator.of(context).pop(true);
  void _cancel(BuildContext context) => Navigator.of(context).pop(false);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Are you sure?'),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      children: [
        message == null ? const SizedBox(height: 5) : Text(message!),
        DialogButtons(
          onConfirm: () => _confirm(context),
          onCancel: () => _cancel(context),
          confirmText: 'Sign out',
          confirmStyle: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
