
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AssetIndexWrapper extends SingleChildRenderObjectWidget {
  final int rowIndex;
  final int sectionIndex;

  const AssetIndexWrapper({
    required Widget super.child,
    required this.rowIndex,
    required this.sectionIndex,
    super.key,
  });

  @override
  _AssetIndexProxy createRenderObject(BuildContext context) {
    return _AssetIndexProxy(
      index: AssetIndex(rowIndex: rowIndex, sectionIndex: sectionIndex),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _AssetIndexProxy renderObject,
  ) {
    renderObject.index =
        AssetIndex(rowIndex: rowIndex, sectionIndex: sectionIndex);
  }
}

class _AssetIndexProxy extends RenderProxyBox {
  AssetIndex index;

  _AssetIndexProxy({
    required this.index,
  });
}

class AssetIndex {
  final int rowIndex;
  final int sectionIndex;

  const AssetIndex({
    required this.rowIndex,
    required this.sectionIndex,
  });

  @override
  bool operator ==(covariant AssetIndex other) {
    if (identical(this, other)) return true;

    return other.rowIndex == rowIndex && other.sectionIndex == sectionIndex;
  }

  @override
  int get hashCode => rowIndex.hashCode ^ sectionIndex.hashCode;
}
