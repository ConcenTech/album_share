import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/app_snackbar.dart';
import '../utils/app_localisations.dart';
import 'app_dialog.dart';

const _dontKillMyAppUrl = 'https://dontkillmyapp.com';

Future<void> showBatteryOptimisationsDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => const _BatteryOptimisationsDialog(),
  );
}

class _BatteryOptimisationsDialog extends StatelessWidget {
  const _BatteryOptimisationsDialog();

  void _launchUrl(BuildContext context) async {
    if (!await launchUrl(Uri.parse(_dontKillMyAppUrl)) && context.mounted) {
      AppSnackbar.warning(context: context, message: 'Failed to load page.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return AppDialog(
      title: locale.batteryOptimisations,
      onConfirm: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(locale.batteryOptimisationsMessage),
          TextButton(
            onPressed: () => _launchUrl(context),
            child: const Text(_dontKillMyAppUrl),
          ),
        ],
      ),
    );
  }
}
