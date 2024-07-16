import 'package:album_share/core/utils/extension_methods.dart';
import 'package:album_share/immich/asset_grid/asset_grid_data_structure.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

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
      title: const Text(kGroupBy),
      trailing: SizedBox(
        width: 90,
        // height: 60
        child: DropdownButtonFormField(
          value: value,
          items: GroupAssetsBy.values.mapList((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.display),
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
