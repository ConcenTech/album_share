import 'package:flutter/material.dart';

import '../../core/components/logo_widget.dart';
import '../../core/utils/app_localisations.dart';
import '../../services/database/database_service.dart';
import 'themed_material_scaffold.dart';

class InitFailScreen extends StatelessWidget {
  const InitFailScreen(this.error, {super.key});

  final Object? error;

  Widget _buildErrorText(AppLocalizations locale) {
    switch (error) {
      case final DatabaseException e:
        return Text('${e.message}' '\n${e.details}');
      case null:
        return Text(locale.unknownError);
      default:
        return Text('$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return ThemedMaterialScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LogoImageText(),
            const SizedBox(height: 8),
            Text(locale.appInitError),
            _buildErrorText(locale),
          ],
        ),
      ),
    );
  }
}
