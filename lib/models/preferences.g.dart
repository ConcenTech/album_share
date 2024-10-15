// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPreferencesCollection on Isar {
  IsarCollection<Preferences> get preferences => this.collection();
}

const PreferencesSchema = CollectionSchema(
  name: r'Preferences',
  id: 4252616732994050084,
  properties: {
    r'backgroundSync': PropertySchema(
      id: 0,
      name: r'backgroundSync',
      type: IsarType.bool,
    ),
    r'dynamicLayout': PropertySchema(
      id: 1,
      name: r'dynamicLayout',
      type: IsarType.bool,
    ),
    r'enableHapticFeedback': PropertySchema(
      id: 2,
      name: r'enableHapticFeedback',
      type: IsarType.bool,
    ),
    r'groupBy': PropertySchema(
      id: 3,
      name: r'groupBy',
      type: IsarType.byte,
      enumMap: _PreferencesgroupByEnumValueMap,
    ),
    r'loadOriginal': PropertySchema(
      id: 4,
      name: r'loadOriginal',
      type: IsarType.bool,
    ),
    r'loadPreview': PropertySchema(
      id: 5,
      name: r'loadPreview',
      type: IsarType.bool,
    ),
    r'loopVideos': PropertySchema(
      id: 6,
      name: r'loopVideos',
      type: IsarType.bool,
    ),
    r'maxExtent': PropertySchema(
      id: 7,
      name: r'maxExtent',
      type: IsarType.long,
    ),
    r'syncFrequency': PropertySchema(
      id: 8,
      name: r'syncFrequency',
      type: IsarType.long,
    ),
    r'theme': PropertySchema(
      id: 9,
      name: r'theme',
      type: IsarType.byte,
      enumMap: _PreferencesthemeEnumValueMap,
    )
  },
  estimateSize: _preferencesEstimateSize,
  serialize: _preferencesSerialize,
  deserialize: _preferencesDeserialize,
  deserializeProp: _preferencesDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _preferencesGetId,
  getLinks: _preferencesGetLinks,
  attach: _preferencesAttach,
  version: '3.1.8',
);

int _preferencesEstimateSize(
  Preferences object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _preferencesSerialize(
  Preferences object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.backgroundSync);
  writer.writeBool(offsets[1], object.dynamicLayout);
  writer.writeBool(offsets[2], object.enableHapticFeedback);
  writer.writeByte(offsets[3], object.groupBy.index);
  writer.writeBool(offsets[4], object.loadOriginal);
  writer.writeBool(offsets[5], object.loadPreview);
  writer.writeBool(offsets[6], object.loopVideos);
  writer.writeLong(offsets[7], object.maxExtent);
  writer.writeLong(offsets[8], object.syncFrequency);
  writer.writeByte(offsets[9], object.theme.index);
}

Preferences _preferencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Preferences(
    backgroundSync: reader.readBoolOrNull(offsets[0]),
    dynamicLayout: reader.readBoolOrNull(offsets[1]) ?? true,
    enableHapticFeedback: reader.readBoolOrNull(offsets[2]) ?? true,
    groupBy:
        _PreferencesgroupByValueEnumMap[reader.readByteOrNull(offsets[3])] ??
            GroupAssetsBy.auto,
    loadOriginal: reader.readBoolOrNull(offsets[4]) ?? false,
    loadPreview: reader.readBoolOrNull(offsets[5]) ?? true,
    loopVideos: reader.readBoolOrNull(offsets[6]) ?? false,
    maxExtent: reader.readLongOrNull(offsets[7]) ?? 90,
    syncFrequency: reader.readLongOrNull(offsets[8]) ?? 300,
    theme: _PreferencesthemeValueEnumMap[reader.readByteOrNull(offsets[9])] ??
        ThemeMode.system,
  );
  return object;
}

P _preferencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 3:
      return (_PreferencesgroupByValueEnumMap[reader.readByteOrNull(offset)] ??
          GroupAssetsBy.auto) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 90) as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 300) as P;
    case 9:
      return (_PreferencesthemeValueEnumMap[reader.readByteOrNull(offset)] ??
          ThemeMode.system) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PreferencesgroupByEnumValueMap = {
  'day': 0,
  'month': 1,
  'auto': 2,
  'none': 3,
};
const _PreferencesgroupByValueEnumMap = {
  0: GroupAssetsBy.day,
  1: GroupAssetsBy.month,
  2: GroupAssetsBy.auto,
  3: GroupAssetsBy.none,
};
const _PreferencesthemeEnumValueMap = {
  'system': 0,
  'light': 1,
  'dark': 2,
};
const _PreferencesthemeValueEnumMap = {
  0: ThemeMode.system,
  1: ThemeMode.light,
  2: ThemeMode.dark,
};

Id _preferencesGetId(Preferences object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _preferencesGetLinks(Preferences object) {
  return [];
}

void _preferencesAttach(
    IsarCollection<dynamic> col, Id id, Preferences object) {}

extension PreferencesQueryWhereSort
    on QueryBuilder<Preferences, Preferences, QWhere> {
  QueryBuilder<Preferences, Preferences, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PreferencesQueryWhere
    on QueryBuilder<Preferences, Preferences, QWhereClause> {
  QueryBuilder<Preferences, Preferences, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<Preferences, Preferences, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterWhereClause> isarIdBetween(
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

extension PreferencesQueryFilter
    on QueryBuilder<Preferences, Preferences, QFilterCondition> {
  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      backgroundSyncIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'backgroundSync',
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      backgroundSyncIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'backgroundSync',
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      backgroundSyncEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backgroundSync',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      dynamicLayoutEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dynamicLayout',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      enableHapticFeedbackEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableHapticFeedback',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> groupByEqualTo(
      GroupAssetsBy value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupBy',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      groupByGreaterThan(
    GroupAssetsBy value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupBy',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> groupByLessThan(
    GroupAssetsBy value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupBy',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> groupByBetween(
    GroupAssetsBy lower,
    GroupAssetsBy upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      isarIdGreaterThan(
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

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      loadOriginalEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loadOriginal',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      loadPreviewEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loadPreview',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      loopVideosEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loopVideos',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      maxExtentEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxExtent',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      maxExtentGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxExtent',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      maxExtentLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxExtent',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      maxExtentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxExtent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      syncFrequencyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      syncFrequencyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      syncFrequencyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      syncFrequencyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeEqualTo(
      ThemeMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition>
      themeGreaterThan(
    ThemeMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'theme',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeLessThan(
    ThemeMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'theme',
        value: value,
      ));
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterFilterCondition> themeBetween(
    ThemeMode lower,
    ThemeMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'theme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PreferencesQueryObject
    on QueryBuilder<Preferences, Preferences, QFilterCondition> {}

extension PreferencesQueryLinks
    on QueryBuilder<Preferences, Preferences, QFilterCondition> {}

extension PreferencesQuerySortBy
    on QueryBuilder<Preferences, Preferences, QSortBy> {
  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByBackgroundSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundSync', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByBackgroundSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundSync', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByDynamicLayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dynamicLayout', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByDynamicLayoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dynamicLayout', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByEnableHapticFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHapticFeedback', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByEnableHapticFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHapticFeedback', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByGroupBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupBy', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByGroupByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupBy', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByLoadOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadOriginal', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortByLoadOriginalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadOriginal', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByLoadPreview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadPreview', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByLoadPreviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadPreview', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByLoopVideos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loopVideos', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByLoopVideosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loopVideos', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByMaxExtent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxExtent', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByMaxExtentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxExtent', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortBySyncFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncFrequency', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      sortBySyncFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncFrequency', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> sortByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }
}

extension PreferencesQuerySortThenBy
    on QueryBuilder<Preferences, Preferences, QSortThenBy> {
  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByBackgroundSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundSync', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByBackgroundSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundSync', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByDynamicLayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dynamicLayout', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByDynamicLayoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dynamicLayout', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByEnableHapticFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHapticFeedback', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByEnableHapticFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHapticFeedback', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByGroupBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupBy', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByGroupByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupBy', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByLoadOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadOriginal', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenByLoadOriginalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadOriginal', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByLoadPreview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadPreview', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByLoadPreviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadPreview', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByLoopVideos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loopVideos', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByLoopVideosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loopVideos', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByMaxExtent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxExtent', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByMaxExtentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxExtent', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenBySyncFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncFrequency', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy>
      thenBySyncFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncFrequency', Sort.desc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<Preferences, Preferences, QAfterSortBy> thenByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }
}

extension PreferencesQueryWhereDistinct
    on QueryBuilder<Preferences, Preferences, QDistinct> {
  QueryBuilder<Preferences, Preferences, QDistinct> distinctByBackgroundSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backgroundSync');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByDynamicLayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dynamicLayout');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct>
      distinctByEnableHapticFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableHapticFeedback');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByGroupBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupBy');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByLoadOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loadOriginal');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByLoadPreview() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loadPreview');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByLoopVideos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loopVideos');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByMaxExtent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxExtent');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctBySyncFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncFrequency');
    });
  }

  QueryBuilder<Preferences, Preferences, QDistinct> distinctByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'theme');
    });
  }
}

extension PreferencesQueryProperty
    on QueryBuilder<Preferences, Preferences, QQueryProperty> {
  QueryBuilder<Preferences, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Preferences, bool?, QQueryOperations> backgroundSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backgroundSync');
    });
  }

  QueryBuilder<Preferences, bool, QQueryOperations> dynamicLayoutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dynamicLayout');
    });
  }

  QueryBuilder<Preferences, bool, QQueryOperations>
      enableHapticFeedbackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableHapticFeedback');
    });
  }

  QueryBuilder<Preferences, GroupAssetsBy, QQueryOperations> groupByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupBy');
    });
  }

  QueryBuilder<Preferences, bool, QQueryOperations> loadOriginalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loadOriginal');
    });
  }

  QueryBuilder<Preferences, bool, QQueryOperations> loadPreviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loadPreview');
    });
  }

  QueryBuilder<Preferences, bool, QQueryOperations> loopVideosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loopVideos');
    });
  }

  QueryBuilder<Preferences, int, QQueryOperations> maxExtentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxExtent');
    });
  }

  QueryBuilder<Preferences, int, QQueryOperations> syncFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncFrequency');
    });
  }

  QueryBuilder<Preferences, ThemeMode, QQueryOperations> themeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'theme');
    });
  }
}
