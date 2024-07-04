import 'package:flutter/material.dart';

import '../../core/components/logo_widget.dart';
import 'themed_material_scaffold.dart';

class InitFailScreen extends StatelessWidget {
  const InitFailScreen({this.error, super.key});

  final String? error;

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
            if (error != null) Text(error!),
          ],
        ),
      ),
    );
  }
}
