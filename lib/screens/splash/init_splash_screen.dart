import 'package:flutter/material.dart';

import '../../core/components/logo_widget.dart';
import 'themed_material_scaffold.dart';

class InitSplashScreen extends StatelessWidget {
  const InitSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemedMaterialScaffold(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoImageText(),
             Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
