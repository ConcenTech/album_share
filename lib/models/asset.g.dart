// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssetCollection on Isar {
  IsarCollection<Asset> get assets => this.collection();
}

const AssetSchema = CollectionSchema(
  name: r'Asset',
  id: -2933289051367723566,
  properties: {
    r'albums': PropertySchema(
      id: 0,
      name: r'albums',
      type: IsarType.stringList,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'durationString': PropertySchema(
      id: 2,
      name: r'durationString',
      type: IsarType.string,
    ),
    r'fileName': PropertySchema(
      id: 3,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 4,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'height': PropertySchema(
      id: 5,
      name: r'height',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 6,
      name: r'id',
      type: IsarType.string,
    ),
    r'livePhotoVideoId': PropertySchema(
      id: 7,
      name: r'livePhotoVideoId',
      type: IsarType.string,
    ),
    r'ownerId': PropertySchema(
      id: 8,
      name: r'ownerId',
      type: IsarType.string,
    ),
    r'stackCount': PropertySchema(
      id: 9,
      name: r'stackCount',
      type: IsarType.long,
    ),
    r'thumbHash': PropertySchema(
      id: 10,
      name: r'thumbHash',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.byte,
      enumMap: _AssettypeEnumValueMap,
    ),
    r'width': PropertySchema(
      id: 12,
      name: r'width',
      type: IsarType.long,
    )
  },
  estimateSize: _assetEstimateSize,
  serialize: _assetSerialize,
  deserialize: _assetDeserialize,
  deserializeProp: _assetDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _assetGetId,
  getLinks: _assetGetLinks,
  attach: _assetAttach,
  version: '3.1.8',
);

int _assetEstimateSize(
  Asset object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albums.length * 3;
  {
    for (var i = 0; i < object.albums.length; i++) {
      final value = object.albums[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.durationString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fileName.length * 3;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.livePhotoVideoId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.ownerId.length * 3;
  {
    final value = object.thumbHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _assetSerialize(
  Asset object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.albums);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.durationString);
  writer.writeString(offsets[3], object.fileName);
  writer.writeLong(offsets[4], object.hashCode);
  writer.writeLong(offsets[5], object.height);
  writer.writeString(offsets[6], object.id);
  writer.writeString(offsets[7], object.livePhotoVideoId);
  writer.writeString(offsets[8], object.ownerId);
  writer.writeLong(offsets[9], object.stackCount);
  writer.writeString(offsets[10], object.thumbHash);
  writer.writeByte(offsets[11], object.type.index);
  writer.writeLong(offsets[12], object.width);
}

Asset _assetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Asset(
    albums: reader.readStringList(offsets[0]) ?? [],
    createdAt: reader.readDateTime(offsets[1]),
    durationString: reader.readStringOrNull(offsets[2]),
    fileName: reader.readString(offsets[3]),
    height: reader.readLongOrNull(offsets[5]),
    id: reader.readString(offsets[6]),
    livePhotoVideoId: reader.readStringOrNull(offsets[7]),
    ownerId: reader.readString(offsets[8]),
    stackCount: reader.readLongOrNull(offsets[9]),
    thumbHash: reader.readStringOrNull(offsets[10]),
    type: _AssettypeValueEnumMap[reader.readByteOrNull(offsets[11])] ??
        AssetType.image,
    width: reader.readLongOrNull(offsets[12]),
  );
  return object;
}

P _assetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (_AssettypeValueEnumMap[reader.readByteOrNull(offset)] ??
          AssetType.image) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AssettypeEnumValueMap = {
  'image': 0,
  'video': 1,
  'audio': 2,
  'other': 3,
};
const _AssettypeValueEnumMap = {
  0: AssetType.image,
  1: AssetType.video,
  2: AssetType.audio,
  3: AssetType.other,
};

Id _assetGetId(Asset object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _assetGetLinks(Asset object) {
  return [];
}

void _assetAttach(IsarCollection<dynamic> col, Id id, Asset object) {}

extension AssetQueryWhereSort on QueryBuilder<Asset, Asset, QWhere> {
  QueryBuilder<Asset, Asset, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssetQueryWhere on QueryBuilder<Asset, Asset, QWhereClause> {
  QueryBuilder<Asset, Asset, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Asset, Asset, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Asset, Asset, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Asset, Asset, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AssetQueryFilter on QueryBuilder<Asset, Asset, QFilterCondition> {
  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albums',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'albums',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'albums',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'albums',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'albums',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'albums',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'albums',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'albums',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albums',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albums',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albums',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albums',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albums',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albums',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albums',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> albumsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'albums',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationString',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationString',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'durationString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'durationString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'durationString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'durationString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationString',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> durationStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'durationString',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> heightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'height',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> heightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'height',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> heightEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> heightGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> heightLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> heightBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'livePhotoVideoId',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition>
      livePhotoVideoIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'livePhotoVideoId',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'livePhotoVideoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'livePhotoVideoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'livePhotoVideoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'livePhotoVideoId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'livePhotoVideoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'livePhotoVideoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'livePhotoVideoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'livePhotoVideoId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> livePhotoVideoIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'livePhotoVideoId',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition>
      livePhotoVideoIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'livePhotoVideoId',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerId',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> ownerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerId',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> stackCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stackCount',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> stackCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stackCount',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> stackCountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stackCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> stackCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stackCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> stackCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stackCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> stackCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stackCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'thumbHash',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'thumbHash',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'thumbHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'thumbHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'thumbHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'thumbHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'thumbHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'thumbHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'thumbHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbHash',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> thumbHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'thumbHash',
        value: '',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> typeEqualTo(
      AssetType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> typeGreaterThan(
    AssetType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> typeLessThan(
    AssetType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> typeBetween(
    AssetType lower,
    AssetType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> widthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'width',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> widthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'width',
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> widthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> widthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> widthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
      ));
    });
  }

  QueryBuilder<Asset, Asset, QAfterFilterCondition> widthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AssetQueryObject on QueryBuilder<Asset, Asset, QFilterCondition> {}

extension AssetQueryLinks on QueryBuilder<Asset, Asset, QFilterCondition> {}

extension AssetQuerySortBy on QueryBuilder<Asset, Asset, QSortBy> {
  QueryBuilder<Asset, Asset, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByDurationString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationString', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByDurationStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationString', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByLivePhotoVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'livePhotoVideoId', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByLivePhotoVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'livePhotoVideoId', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByStackCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stackCount', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByStackCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stackCount', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByThumbHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbHash', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByThumbHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbHash', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension AssetQuerySortThenBy on QueryBuilder<Asset, Asset, QSortThenBy> {
  QueryBuilder<Asset, Asset, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByDurationString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationString', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByDurationStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationString', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByLivePhotoVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'livePhotoVideoId', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByLivePhotoVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'livePhotoVideoId', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByStackCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stackCount', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByStackCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stackCount', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByThumbHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbHash', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByThumbHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbHash', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<Asset, Asset, QAfterSortBy> thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension AssetQueryWhereDistinct on QueryBuilder<Asset, Asset, QDistinct> {
  QueryBuilder<Asset, Asset, QDistinct> distinctByAlbums() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albums');
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByDurationString(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByFileName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByLivePhotoVideoId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'livePhotoVideoId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByOwnerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByStackCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stackCount');
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByThumbHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thumbHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<Asset, Asset, QDistinct> distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension AssetQueryProperty on QueryBuilder<Asset, Asset, QQueryProperty> {
  QueryBuilder<Asset, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Asset, List<String>, QQueryOperations> albumsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albums');
    });
  }

  QueryBuilder<Asset, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Asset, String?, QQueryOperations> durationStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationString');
    });
  }

  QueryBuilder<Asset, String, QQueryOperations> fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<Asset, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<Asset, int?, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<Asset, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Asset, String?, QQueryOperations> livePhotoVideoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'livePhotoVideoId');
    });
  }

  QueryBuilder<Asset, String, QQueryOperations> ownerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerId');
    });
  }

  QueryBuilder<Asset, int?, QQueryOperations> stackCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stackCount');
    });
  }

  QueryBuilder<Asset, String?, QQueryOperations> thumbHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thumbHash');
    });
  }

  QueryBuilder<Asset, AssetType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Asset, int?, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}
