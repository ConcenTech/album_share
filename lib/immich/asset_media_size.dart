enum AssetMediaSize {
  preview,
  thumbnail,;

  factory AssetMediaSize.fromString(String value){
    return AssetMediaSize.values.firstWhere((v) => v.name == value);
  }
}
