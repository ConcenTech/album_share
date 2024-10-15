import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import '../../core/utils/app_localisations.dart';
import '../../models/asset.dart';

final log = Logger('AssetGridDataStructure');

enum RenderAssetGridElementType {
  assets,
  assetRow,
  groupDividerTitle,
  monthTitle;
}

class RenderAssetGridElement {
  final RenderAssetGridElementType type;
  final String? title;
  final DateTime date;
  final int count;
  final int offset;
  final int totalCount;

  RenderAssetGridElement(
    this.type, {
    this.title,
    required this.date,
    this.count = 0,
    this.offset = 0,
    this.totalCount = 0,
  });
}

enum GroupAssetsBy {
  day,
  month,
  auto,
  none,
  ;

  String get display {
    return switch (this) {
      GroupAssetsBy.day => 'Day',
      GroupAssetsBy.month => 'Month',
      GroupAssetsBy.auto => 'Auto',
      GroupAssetsBy.none => 'None',
    };
  }

  String localised(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return switch (this) {
      GroupAssetsBy.day => locale.day,
      GroupAssetsBy.month => locale.month,
      GroupAssetsBy.auto => locale.automatic,
      GroupAssetsBy.none => locale.none,
    };
  }
}

class RenderList {
  final List<RenderAssetGridElement> elements;
  final List<Asset> allAssets;
  final int totalAssets;

  RenderList(this.elements, this.allAssets) : totalAssets = allAssets.length;

  bool get isEmpty => totalAssets == 0;

  /// Loads the requested assets from the database to an internal buffer if not cached
  /// and returns a slice of that buffer
  List<Asset> loadAssets(int offset, int count) {
    assert(offset >= 0);
    assert(count > 0);
    assert(offset + count <= totalAssets);
    return allAssets.slice(offset, offset + count);
  }

  /// Returns the requested asset either from cached buffer or directly from the database
  Asset loadAsset(int index) {
    return allAssets[index];
  }

  static RenderList _buildRenderList(
    List<Asset> assets,
    GroupAssetsBy groupBy,
  ) {
    final List<RenderAssetGridElement> elements = [];

    const sectionSize = 60; // divides evenly by 2,3,4,5,6

    if (groupBy == GroupAssetsBy.none) {
      final int total = assets.length;
      for (int i = 0; i < total; i += sectionSize) {
        final date = assets[i].createdAt;

        final int count = i + sectionSize > total ? total - i : sectionSize;
        elements.add(
          RenderAssetGridElement(
            RenderAssetGridElementType.assets,
            date: date,
            count: count,
            totalCount: total,
            offset: i,
          ),
        );
      }
      return RenderList(elements, assets);
    }

    final formatSameYear =
        groupBy == GroupAssetsBy.month ? DateFormat.MMMM() : DateFormat.MMMEd();
    final formatOtherYear = groupBy == GroupAssetsBy.month
        ? DateFormat.yMMMM()
        : DateFormat.yMMMEd();
    final currentYear = DateTime.now().year;
    final formatMergedSameYear = DateFormat.MMMd();
    final formatMergedOtherYear = DateFormat.yMMMd();

    int offset = 0;
    DateTime? last;
    DateTime? current;
    int lastOffset = 0;
    int count = 0;
    int monthCount = 0;
    int lastMonthIndex = 0;

    String formatDateRange(DateTime from, DateTime to) {
      final startDate = (from.year == currentYear
              ? formatMergedSameYear
              : formatMergedOtherYear)
          .format(from);
      final endDate = (to.year == currentYear
              ? formatMergedSameYear
              : formatMergedOtherYear)
          .format(to);
      if (DateTime(from.year, from.month, from.day) ==
          DateTime(to.year, to.month, to.day)) {
        // format range with time when both dates are on the same day
        final startTime = DateFormat.Hm().format(from);
        final endTime = DateFormat.Hm().format(to);
        return "$startDate $startTime - $endTime";
      }
      return "$startDate - $endDate";
    }

    void mergeMonth() {
      if (last != null &&
          groupBy == GroupAssetsBy.auto &&
          monthCount <= 30 &&
          elements.length > lastMonthIndex + 1) {
        // merge all days into a single section
        assert(elements[lastMonthIndex].date.month == last.month);
        final e = elements[lastMonthIndex];

        elements[lastMonthIndex] = RenderAssetGridElement(
          RenderAssetGridElementType.monthTitle,
          date: e.date,
          count: monthCount,
          totalCount: monthCount,
          offset: e.offset,
          title: formatDateRange(e.date, elements.last.date),
        );
        elements.removeRange(lastMonthIndex + 1, elements.length);
      }
    }

    void addElems(DateTime d, DateTime? prevDate) {
      final bool newMonth =
          last == null || last.year != d.year || last.month != d.month;
      if (newMonth) {
        mergeMonth();
        lastMonthIndex = elements.length;
        monthCount = 0;
      }
      for (int j = 0; j < count; j += sectionSize) {
        final type = j == 0
            ? (groupBy != GroupAssetsBy.month && newMonth
                ? RenderAssetGridElementType.monthTitle
                : RenderAssetGridElementType.groupDividerTitle)
            : (groupBy == GroupAssetsBy.auto
                ? RenderAssetGridElementType.groupDividerTitle
                : RenderAssetGridElementType.assets);
        final sectionCount = j + sectionSize > count ? count - j : sectionSize;
        assert(sectionCount > 0 && sectionCount <= sectionSize);
        elements.add(
          RenderAssetGridElement(
            type,
            date: d,
            count: sectionCount,
            totalCount: groupBy == GroupAssetsBy.auto ? sectionCount : count,
            offset: lastOffset + j,
            title: j == 0
                ? (d.year == currentYear
                    ? formatSameYear.format(d)
                    : formatOtherYear.format(d))
                : (groupBy == GroupAssetsBy.auto
                    ? formatDateRange(d, prevDate ?? d)
                    : null),
          ),
        );
      }
      monthCount += count;
    }

    DateTime? prevDate;
    final dates = assets.map((a) => a.createdAt);

    int i = 0;
    for (final date in dates) {
      final d = DateTime(
        date.year,
        date.month,
        groupBy == GroupAssetsBy.month ? 1 : date.day,
      );
      current ??= d;
      if (current != d) {
        addElems(current, prevDate);
        last = current;
        current = d;
        lastOffset = offset + i;
        count = 0;
      }
      prevDate = date;
      count++;
      i++;
    }

    if (count > 0 && current != null) {
      addElems(current, prevDate);
      mergeMonth();
    }
    assert(elements.every((e) => e.count <= sectionSize), "too large section");
    return RenderList(elements, assets);
  }

  static RenderList empty() => RenderList([], []);

  static RenderList fromAssets(
    List<Asset> assets,
    GroupAssetsBy groupBy,
  ) =>
      _buildRenderList(assets, groupBy);

  /// Deletes an asset from the render list and clears the buffer
  /// This is only a workaround for deleted images still appearing in the gallery
  void deleteAsset(Asset deleteAsset) {
    allAssets.remove(deleteAsset);
  }
}
