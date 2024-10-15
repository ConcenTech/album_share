// Credit: Immich
import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/components/app_snackbar.dart';
import '../../core/components/scaffold/app_scaffold.dart';
import '../../core/utils/extension_methods.dart';
import '../../models/asset.dart';
import '../../screens/asset_viewer/asset_viewer_screen_state.dart';
import '../../services/providers/app_bar_listener.dart';
import '../extensions/build_context_extensions.dart';
import '../extensions/collection_extensions.dart';
import '../providers/haptic_feedback.provider.dart';
import '../providers/scroll_notifier.provider.dart';
import '../providers/scroll_to_date_notifier.provider.dart';
import 'asset_drag_region.dart';
import 'asset_grid_data_structure.dart';
import 'draggable_scrollbar_custom.dart';
import 'group_divider_title.dart';
import 'thumbnail_image.dart';
import 'thumbnail_placeholder.dart';

typedef ImmichAssetGridSelectionListener = void Function(
  bool,
  Set<Asset>,
);

class ImmichAssetGridView extends ConsumerStatefulWidget {
  final RenderList renderList;
  final int assetMaxExtent;
  final double margin;
  final ImmichAssetGridSelectionListener? listener;
  final Future<void> Function()? onRefresh;
  final bool dynamicLayout;
  final void Function(Iterable<ItemPosition> itemPositions)?
      visibleItemsListener;
  final int heroOffset;
  final bool shrinkWrap;
  final bool alwaysVisibleScrollThumb;
  final bool showDragScroll;
  final bool showStack;
  final void Function(AssetViewerScreenState state) onTap;

  const ImmichAssetGridView({
    super.key,
    required this.renderList,
    required this.assetMaxExtent,
    this.listener,
    this.margin = 5.0,
    this.onRefresh,
    this.dynamicLayout = true,
    this.visibleItemsListener,
    this.heroOffset = 0,
    this.shrinkWrap = false,
    this.alwaysVisibleScrollThumb = false,
    this.showDragScroll = true,
    this.showStack = false,
    required this.onTap,
  });

  @override
  createState() {
    return ImmichAssetGridViewState();
  }
}

class ImmichAssetGridViewState extends ConsumerState<ImmichAssetGridView> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ScrollOffsetController _scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  /// The index of the first item visible on screen at the current time.
  int _indexInView = 0;

  /// The offset of the first item visible on screen, from the top of the screen.
  double _indexInViewOffset = 0;

  /// The timestamp when the haptic feedback was last invoked
  int _hapticFeedbackTS = 0;
  DateTime? _prevItemTime;

  bool _scrolling = false;

  Future<void> _scrollToIndex(int index) async {
    // if the index is so far down, that the end of the list is reached on the screen
    // the scroll_position widget crashes. This is a workaround to prevent this.
    // If the index is within the last 10 elements, we jump instead of scrolling.
    if (widget.renderList.elements.length <= index + 10) {
      _itemScrollController.jumpTo(
        index: index,
      );
      return;
    }
    await _itemScrollController.scrollTo(
      index: index,
      alignment: 0,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget _itemBuilder(BuildContext c, int index) {
    final section = widget.renderList.elements[index];
    return _Section(
      sectionIndex: index,
      section: section,
      margin: widget.margin,
      renderList: widget.renderList,
      assetMaxExtent: widget.assetMaxExtent,
      scrolling: _scrolling,
      dynamicLayout: widget.dynamicLayout,
      showStack: widget.showStack,
      heroOffset: widget.heroOffset,
      onTap: widget.onTap,
    );
  }

  Text _labelBuilder(int pos) {
    final maxLength = widget.renderList.elements.length;
    if (pos < 0 || pos >= maxLength) {
      return const Text("");
    }

    final date = widget.renderList.elements[pos % maxLength].date;

    return Text(
      DateFormat.yMMMM().format(date),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _scrollToDate() {
    final date = scrollToDateNotifierProvider.value;
    if (date == null) {
      AppSnackbar.warning(
        context: context,
        message: 'Scroll To Date failed, date is null',
      );
      return;
    }

    // Search for the index of the exact date in the list
    var index = widget.renderList.elements.indexWhere(
      (e) =>
          e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day,
    );

    // If the exact date is not found, the timeline is grouped by month,
    // thus we search for the month
    if (index == -1) {
      index = widget.renderList.elements.indexWhere(
        (e) => e.date.year == date.year && e.date.month == date.month,
      );
    }

    if (index != -1 && index < widget.renderList.elements.length) {
      // Not sure why the index is shifted, but it works. :3
      _scrollToIndex(index + 1);
    } else {
      AppSnackbar.warning(
        context: context,
        message: 'The date (${DateFormat.yMd().format(date)})'
            'could not be found in the timeline.',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    scrollToTopNotifierProvider.addListener(_scrollToTop);
    scrollToDateNotifierProvider.addListener(_scrollToDate);

    if (widget.visibleItemsListener != null) {
      _itemPositionsListener.itemPositions.addListener(_positionListener);
    }

    _itemPositionsListener.itemPositions.addListener(_offSetListener);
    _itemPositionsListener.itemPositions.addListener(_hapticsListener);
  }

  @override
  void dispose() {
    scrollToTopNotifierProvider.removeListener(_scrollToTop);
    scrollToDateNotifierProvider.removeListener(_scrollToDate);
    if (widget.visibleItemsListener != null) {
      _itemPositionsListener.itemPositions.removeListener(_positionListener);
    }
    _itemPositionsListener.itemPositions.removeListener(_offSetListener);
    _itemPositionsListener.itemPositions.removeListener(_hapticsListener);

    super.dispose();
  }

  void _offSetListener() {
    final positions = _itemPositionsListener.itemPositions.value;
    final firstInView = positions.firstOrNull;
    if (firstInView == null) {
      return;
    }
    void saveOffset() {
      _indexInViewOffset = firstInView.itemLeadingEdge;
    }

    void saveIndex() {
      _indexInView = firstInView.index;
    }

    if (firstInView.index == _indexInView &&
        firstInView.itemLeadingEdge == _indexInViewOffset) {
      return;
    }

    if (firstInView.index > _indexInView) {
      saveIndex();
      saveOffset();
      return _hideAppBar();
    }
    if (firstInView.index < _indexInView || firstInView.index < 1) {
      saveIndex();
      saveOffset();
      return _showAppBar();
    }

    final diff = firstInView.itemLeadingEdge.difference(_indexInViewOffset);
    if (diff > 0.1) {
      saveOffset();
      return _showAppBar();
    }

    if (diff < -0.1) {
      saveOffset();
      return _hideAppBar();
    }
  }

  void _showAppBar() {
    ref.read(appBarListenerProvider.notifier).show();
  }

  void _hideAppBar() {
    ref.read(appBarListenerProvider.notifier).hide();
  }

  void _positionListener() {
    final values = _itemPositionsListener.itemPositions.value;
    widget.visibleItemsListener?.call(values);
  }

  void _hapticsListener() {
    /// throttle interval for the haptic feedback in microseconds.
    /// Currently set to 100ms.
    const feedbackInterval = 100000;

    final values = _itemPositionsListener.itemPositions.value;
    final start = values.firstOrNull;

    if (start != null) {
      final pos = start.index;
      final maxLength = widget.renderList.elements.length;
      if (pos < 0 || pos >= maxLength) {
        return;
      }

      final date = widget.renderList.elements[pos].date;

      // only provide the feedback if the prev. date is known.
      // Otherwise the app would provide the haptic feedback
      // on startup.
      if (_prevItemTime == null) {
        _prevItemTime = date;
      } else if (_prevItemTime?.year != date.year ||
          _prevItemTime?.month != date.month) {
        _prevItemTime = date;

        final now = Timeline.now;
        if (now > (_hapticFeedbackTS + feedbackInterval)) {
          _hapticFeedbackTS = now;
          ref.read(hapticFeedbackProvider.notifier).mediumImpact();
        }
      }
    }
  }

  void _scrollToTop() {
    // for some reason, this is necessary as well in order
    // to correctly reposition the drag thumb scroll bar
    _itemScrollController.jumpTo(
      index: 0,
    );
    _itemScrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useDragScrolling =
        widget.showDragScroll && widget.renderList.totalAssets >= 20;

    void dragScrolling(bool active) {
      if (active != _scrolling) {
        setState(() {
          _scrolling = active;
        });
      }
    }

    final appBarHeight = AppScaffold.appBarHeight(context);

    final listWidget = ScrollablePositionedList.builder(
      padding: EdgeInsets.only(top: appBarHeight, bottom: 220),
      itemBuilder: _itemBuilder,
      itemPositionsListener: _itemPositionsListener,
      itemScrollController: _itemScrollController,
      scrollOffsetController: _scrollOffsetController,
      itemCount: widget.renderList.elements.length,
      addRepaintBoundaries: true,
      shrinkWrap: widget.shrinkWrap,
    );

    final child = useDragScrolling
        ? DraggableScrollbar.semicircle(
            scrollStateListener: dragScrolling,
            itemPositionsListener: _itemPositionsListener,
            controller: _itemScrollController,
            backgroundColor: context.themeData.hintColor,
            labelTextBuilder: _labelBuilder,
            padding: EdgeInsets.only(top: appBarHeight),
            heightOffset: 60,
            labelConstraints: const BoxConstraints(maxHeight: 28),
            scrollbarAnimationDuration: const Duration(milliseconds: 300),
            scrollbarTimeToFade: const Duration(milliseconds: 1000),
            alwaysVisibleScrollThumb: widget.alwaysVisibleScrollThumb,
            child: listWidget,
          )
        : listWidget;
    return widget.onRefresh == null
        ? child
        : RefreshIndicator(
            onRefresh: widget.onRefresh!,
            edgeOffset: 30,
            child: child,
          );
  }
}

/// A single row of all placeholder widgets
class _PlaceholderRow extends StatelessWidget {
  final int number;
  final double width;
  final double height;
  final double margin;

  const _PlaceholderRow({
    super.key,
    required this.number,
    required this.width,
    required this.height,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < number; i++)
          ThumbnailPlaceholder(
            key: ValueKey(i),
            width: width,
            height: height,
            margin: EdgeInsets.only(
              bottom: margin,
              right: i + 1 == number ? 0.0 : margin,
            ),
          ),
      ],
    );
  }
}

/// A section for the render grid
class _Section extends StatelessWidget {
  final RenderAssetGridElement section;
  final int sectionIndex;
  final bool scrolling;
  final double margin;
  final int assetMaxExtent;
  final RenderList renderList;
  final bool dynamicLayout;
  final bool showStack;
  final int heroOffset;
  final void Function(AssetViewerScreenState state) onTap;

  const _Section({
    required this.section,
    required this.sectionIndex,
    required this.scrolling,
    required this.margin,
    required this.assetMaxExtent,
    required this.renderList,
    required this.dynamicLayout,
    required this.showStack,
    required this.heroOffset,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final assetsPerRow = (constraints.maxWidth / assetMaxExtent).ceil();
        final width = constraints.maxWidth / assetsPerRow -
            margin * (assetsPerRow - 1) / assetsPerRow;
        final rows = (section.count + assetsPerRow - 1) ~/ assetsPerRow;
        final List<Asset> assetsToRender = scrolling
            ? []
            : renderList.loadAssets(section.offset, section.count);
        return Column(
          key: ValueKey(section.offset),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.type == RenderAssetGridElementType.monthTitle)
              _MonthTitle(date: section.date),
            if (section.type == RenderAssetGridElementType.groupDividerTitle ||
                section.type == RenderAssetGridElementType.monthTitle)
              _Title(
                title: section.title!,
                assets: scrolling
                    ? []
                    : renderList.loadAssets(section.offset, section.totalCount),
              ),
            for (int i = 0; i < rows; i++)
              scrolling
                  ? _PlaceholderRow(
                      key: ValueKey(i),
                      number: i + 1 == rows
                          ? section.count - i * assetsPerRow
                          : assetsPerRow,
                      width: width,
                      height: width,
                      margin: margin,
                    )
                  : _AssetRow(
                      key: ValueKey(i),
                      rowStartIndex: i * assetsPerRow,
                      sectionIndex: sectionIndex,
                      assets: assetsToRender.nestedSlice(
                        i * assetsPerRow,
                        min((i + 1) * assetsPerRow, section.count),
                      ),
                      absoluteOffset: section.offset + i * assetsPerRow,
                      width: width,
                      assetsPerRow: assetsPerRow,
                      margin: margin,
                      dynamicLayout: dynamicLayout,
                      renderList: renderList,
                      showStack: showStack,
                      heroOffset: heroOffset,
                      onTap: onTap,
                    ),
          ],
        );
      },
    );
  }
}

/// The month title row for a section
class _MonthTitle extends StatelessWidget {
  final DateTime date;

  const _MonthTitle({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateTime.now().year == date.year
        ? DateFormat.MMMM()
        : DateFormat.yMMMM();
    final String title = monthFormat.format(date);
    return Padding(
      key: Key("month-$title"),
      padding: const EdgeInsets.only(left: 12.0, top: 24.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// A title row
class _Title extends StatelessWidget {
  final String title;
  final List<Asset> assets;

  const _Title({
    required this.title,
    required this.assets,
  });

  @override
  Widget build(BuildContext context) {
    return GroupDividerTitle(text: title);
  }
}

/// The row of assets
class _AssetRow extends StatelessWidget {
  final List<Asset> assets;
  final int rowStartIndex;
  final int sectionIndex;
  final int absoluteOffset;
  final double width;
  final bool dynamicLayout;
  final double margin;
  final int assetsPerRow;
  final RenderList renderList;
  final int heroOffset;
  final bool showStack;
  final void Function(AssetViewerScreenState state) onTap;
  const _AssetRow({
    super.key,
    required this.rowStartIndex,
    required this.sectionIndex,
    required this.assets,
    required this.absoluteOffset,
    required this.width,
    required this.dynamicLayout,
    required this.margin,
    required this.assetsPerRow,
    required this.renderList,
    required this.heroOffset,
    required this.showStack,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Default: All assets have the same width
    final widthDistribution = List.filled(assets.length, 1.0);

    if (dynamicLayout) {
      final aspectRatios =
          assets.map((e) => (e.width ?? 1) / (e.height ?? 1)).toList();
      final meanAspectRatio = aspectRatios.sum / assets.length;

      // 1: mean width
      // 0.5: width < mean - threshold
      // 1.5: width > mean + threshold
      final arConfiguration = aspectRatios.map((e) {
        if (e - meanAspectRatio > 0.3) return 1.5;
        if (e - meanAspectRatio < -0.3) return 0.5;
        return 1.0;
      });

      // Normalize:
      final sum = arConfiguration.sum;
      widthDistribution.setRange(
        0,
        widthDistribution.length,
        arConfiguration.map((e) => (e * assets.length) / sum),
      );
    }
    return Row(
      key: key,
      children: assets.mapIndexed((int index, Asset asset) {
        final bool last = index + 1 == assetsPerRow;

        return Container(
          width: width * widthDistribution[index],
          height: width,
          margin: EdgeInsets.only(
            bottom: margin,
            right: last ? 0.0 : margin,
          ),
          child: GestureDetector(
            onTap: () {
              onTap(AssetViewerScreenState(
                renderList: renderList,
                heroOffset: heroOffset,
                initialIndex: absoluteOffset + index,
                showStack: showStack,
              ));
            },
            child: AssetIndexWrapper(
              rowIndex: rowStartIndex + index,
              sectionIndex: sectionIndex,
              child: ThumbnailImage(
                asset: asset,
                heroOffset: heroOffset,
                showStack: showStack,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
