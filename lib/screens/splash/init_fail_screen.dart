import 'package:album_share/services/database/database_service.dart';
import 'package:flutter/material.dart';

import '../../core/components/logo_widget.dart';
import 'themed_material_scaffold.dart';

class InitFailScreen extends StatelessWidget {
  const InitFailScreen(this.error, {super.key});

  final Object? error;

  Widget _buildErrorText() {
   switch (error) {
     case final DatabaseException e:
      return Text('${e.message}''\n${e.details}');
    case null:
      return const Text('An unknown error occurred');
     default:
     return Text('$error');
   }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedMaterialScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LogoImageText(),
            const SizedBox(height: 8),
            const Text('Error initialising application'),
            _buildErrorText(),
          ],
        ),
      ),
    );
  }
}
