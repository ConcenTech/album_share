import 'package:flutter/material.dart';

import '../utils/app_localisations.dart';
import 'app_dialog.dart';

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
    final locale = AppLocalizations.of(context)!;

    return AppDialog(
      title: locale.areYouSure,
      onConfirm: () => _confirm(context),
      onCancel: () => _cancel(context),
      confirmText: locale.signOut,
      confirmStyle: FilledButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: message == null ? const SizedBox(height: 5) : Text(message!),
    );
  }
}
