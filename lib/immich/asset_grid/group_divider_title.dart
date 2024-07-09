import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/preferences/preferences_providers.dart';
import '../extensions/build_context_extensions.dart';
import 'asset_grid_data_structure.dart';

class GroupDividerTitle extends ConsumerWidget {
  const GroupDividerTitle({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupBy = ref.watch(PreferencesProviders.groupBy);

    return Padding(
      padding: EdgeInsets.only(
        top: groupBy == GroupAssetsBy.month ? 32.0 : 16.0,
        bottom: 16.0,
        left: 12.0,
        right: 12.0,
      ),
      child: Text(
        text,
        style: groupBy == GroupAssetsBy.month
            ? context.textTheme.bodyLarge?.copyWith(
                fontSize: 24.0,
              )
            : context.textTheme.labelLarge?.copyWith(
                color: context.textTheme.labelLarge?.color?.withAlpha(250),
                fontWeight: FontWeight.w500,
              ),
      ),
    );
  }
}
