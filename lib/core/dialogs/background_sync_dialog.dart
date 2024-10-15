import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/notifications/background_notifications/background_notifications_service.dart';
import '../../services/preferences/preferences_providers.dart';
import '../../services/sync/background_sync_service.dart';
import '../components/platform_list_tile.dart';
import '../utils/app_localisations.dart';
import 'app_dialog.dart';
import 'battery_optimisations_dialog.dart';

Future<void> showBackgroundSyncDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => const _BackgroundSyncDialog(),
    barrierDismissible: false,
  );
}

class _BackgroundSyncDialog extends ConsumerWidget {
  const _BackgroundSyncDialog();

  void _save(WidgetRef ref, BuildContext context, bool value) {
    if (value) {
      BackgroundSyncService.instance.register();
    }
    Navigator.of(context).pop();
  }

  void _set(
    WidgetRef ref,
    BuildContext context,
    bool old,
    bool current,
  ) async {
    if (current) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await showBatteryOptimisationsDialog(context);
      }
      await BackgroundNotificationsService.forPlatform().requestPermissions();
    }
    ref
        .read(PreferencesProviders.service.notifier)
        .setValue(backgroundSync: current);
  }

  void Function(bool value)? _canChange(void Function(bool value) callback) {
    if (BackgroundSyncService.isSupportedPlatform()) {
      return callback;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;
    final bgSync = ref.watch(PreferencesProviders.backgroundSync) ?? false;
    return AppDialog(
      title: locale.backgroundSync,
      onConfirm: () => _save(ref, context, bgSync),
      confirmText: locale.save,
      child: PlatformSwitchListTile(
        contentPadding: const EdgeInsets.all(0),
        subtitle: Text(locale.backgroundSyncDescription),
        value: bgSync,
        onChanged: _canChange((v) => _set(ref, context, bgSync, v)),
      ),
    );
  }
}
