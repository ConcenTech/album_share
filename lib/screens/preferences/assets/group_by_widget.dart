import 'package:flutter/material.dart';

import '../../../core/utils/app_localisations.dart';
import '../../../core/utils/extension_methods.dart';
import '../../../immich/asset_grid/asset_grid_data_structure.dart';

class GroupByWidget extends StatelessWidget {
  const GroupByWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final GroupAssetsBy value;
  final void Function(GroupAssetsBy value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.groupBy),
      trailing: SizedBox(
        width: 90,
        // height: 60
        child: DropdownButtonFormField(
          value: value,
          items: GroupAssetsBy.values.mapList((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.localised(context)),
            );
          }),
          autofocus: false,
          onChanged: (v) => onChanged(v!),
          focusColor: Colors.transparent,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
