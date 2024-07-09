import 'dart:convert';
import 'dart:typed_data';

import 'package:thumbhash/thumbhash.dart';

import '../../models/asset.dart';

Uint8List? blurhashFromAsset(Asset? asset) {
  if (asset?.thumbHash == null){
    return null;
  }

   final rbga = thumbHashToRGBA(
    base64Decode(asset!.thumbHash!),
  );

  return rgbaToBmp(rbga);
}