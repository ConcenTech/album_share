import 'package:flutter/material.dart';

import '../../../core/components/platform_list_tile.dart';
import '../../../core/dialogs/battery_optimisations_dialog.dart';
import '../../../core/utils/app_localisations.dart';
import '../../../services/notifications/background_notifications/background_notifications_service.dart';
import '../../../services/sync/background_sync_service.dart';

class BackgroundSyncWidget extends StatelessWidget {
  const BackgroundSyncWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool? value;
  final void Function(bool v) onChanged;

  void _onChanged(bool value, BuildContext context) async {
    if (value && Theme.of(context).platform == TargetPlatform.android) {
      await showBatteryOptimisationsDialog(context);
    }

    if (value) {
      await BackgroundNotificationsService.forPlatform().requestPermissions();
    }

    final bgService = BackgroundSyncService.instance;

    if (value) {
      bgService.register();
    } else {
      bgService.unregister();
    }

    onChanged(value);
  }

  void Function(bool value)? _canChange(void Function(bool value) callback) {
    if (BackgroundSyncService.isSupportedPlatform()) {
      return callback;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return PlatformSwitchListTile(
      title: Text(locale.backgroundSync),
      subtitle: Text(locale.backgroundSyncDescription),
      isThreeLine: true,
      value: value ?? false,
      onChanged: _canChange((v) => _onChanged(v, context)),
    );
  }
}
