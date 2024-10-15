import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/activity.dart';
import '../../../models/album.dart';
import '../../../models/asset.dart';
import '../../../services/activity/activity_providers.dart';
import '../../../services/database/database_providers.dart';
import '../../utils/app_localisations.dart';
import '../../utils/extension_methods.dart';
import '../user_avatar.dart';
import 'app_sidebar.dart';

class ActivitySidebar extends AppSidebar {
  const ActivitySidebar({
    required this.asset,
    this.album,
    super.key,
  });

  final Album? album;
  final Asset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: AppSidebar.width,
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      child: SafeArea(
        top: false,
        child: Consumer(
          builder: (context, ref, child) {
            if (album != null) {
              return _ActivityWidget(
                asset: asset,
                albums: [album!],
              );
            }

            final albumsProvider =
                ref.watch(DatabaseProviders.albums(asset.albums));

            final albums = albumsProvider.maybeWhen(
              data: (albums) => albums,
              orElse: () => <Album>[],
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
            );

            return _ActivityWidget(
              asset: asset,
              albums: albums,
            );
          },
        ),
      ),
    );
  }
}

class _ActivityWidget extends StatefulWidget {
  const _ActivityWidget({
    required this.asset,
    required this.albums,
  });

  final Asset asset;
  final List<Album> albums;

  @override
  State<_ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<_ActivityWidget>
    with TickerProviderStateMixin {
  TabController? _controller;
  int _index = 0;

  Album get _focusedAlbum => widget.albums[_index];

  @override
  void initState() {
    super.initState();
    _setTabController();
  }

  @override
  void didUpdateWidget(covariant _ActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_index <= widget.albums.length) {
      _setTabController();
      _index = _controller!.index;
    }
  }

  void _setTabController() {
    _controller?.dispose();
    _controller = TabController(
      length: widget.albums.length,
      vsync: this,
    );
    _controller!.addListener(_tabChangedListener);
  }

  void _tabChangedListener() {
    setState(() {
      _index = _controller!.index;
    });
  }

  Future<void> _sendMessage(String value, WidgetRef ref) {
    return ref.read(ActivityProviders.uploadService).uploadComment(
          _focusedAlbum.id,
          widget.asset.id,
          value,
        );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabColour = Theme.of(context).colorScheme.onSurface;
    if (widget.albums.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: [
        if (widget.albums.length > 1)
          TabBar(
            controller: _controller,
            indicatorColor: tabColour,
            labelColor: tabColour,
            tabs: widget.albums.mapList(
              (a) => Tab(
                text: a.name,
                height: 30,
              ),
            ),
            dividerColor: Colors.transparent,
          ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.albums.mapList(
              (a) => Consumer(
                builder: (context, ref, child) {
                  final provider = ref.watch(ActivityProviders.assetInAlbum(
                      (album: a, asset: widget.asset)));
                  return provider.when(
                    data: (activity) {
                      if (activity.isEmpty) {
                        return Center(
                          child: Text(AppLocalizations.of(context)!.noActivity),
                        );
                      }
                      return ListView.builder(
                        reverse: true,
                        itemCount: activity.length,
                        itemBuilder: (context, index) {
                          return itemBuilder(context, activity[index]);
                        },
                      );
                    },
                    error: (e, _) {
                      return Center(
                        child: Text('$e'),
                      );
                    },
                    loading: () {
                      return const SizedBox();
                    },
                    skipLoadingOnRefresh: true,
                    skipLoadingOnReload: true,
                  );
                },
              ),
            ),
          ),
        ),
        Consumer(
          builder: (context, ref, child) => _SendMessageWidget(
            onSaved: (value) => _sendMessage(value, ref),
            enabled: _focusedAlbum.isActivityEnabled,
          ),
        ),
      ],
    );
  }

  Widget itemBuilder(BuildContext context, Activity activity) {
    final theme = Theme.of(context);
    const size = 34.0;
    return ListTile(
      leading: SizedBox(
        width: size,
        height: size,
        child: UserAvatar(
          user: activity.user,
          radius: size / 2,
          size: size,
        ),
      ),
      title: Text(activity.user.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activity.comment != null)
            Text(
              activity.comment!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            const Icon(
              Icons.favorite,
              size: 18,
              color: Colors.red,
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              activity.approximateTimeAgo(),
              style: theme.textTheme.labelSmall,
            ),
          ),
        ],
      ),
      titleTextStyle: theme.textTheme.labelMedium,
      subtitleTextStyle: theme.textTheme.bodySmall,
    );
  }
}

class _SendMessageWidget extends StatefulWidget {
  const _SendMessageWidget({
    required this.onSaved,
    required this.enabled,
  });

  final Future<void> Function(String value) onSaved;
  final bool enabled;

  @override
  State<_SendMessageWidget> createState() => __SendMessageWidgetState();
}

class __SendMessageWidgetState extends State<_SendMessageWidget> {
  final TextEditingController _controller = TextEditingController();

  Timer? _timer;

  void _updateButtonVisibility() {
    if (_timer == null) {
      setState(() {});
    } else {
      _timer?.cancel();
    }

    _timer = Timer(
      500.milliseconds,
      () => setState(() => _timer = null),
    );
  }

  void _saveMessage() async {
    await widget.onSaved(_controller.text);
    _controller.clear();
  }

  VoidCallback? _onSaved() {
    return widget.enabled && _controller.text.isNotEmpty ? _saveMessage : null;
  }

  @override
  Widget build(BuildContext context) {
    final onSaved = _onSaved();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        enabled: widget.enabled,
        onChanged: (_) => _updateButtonVisibility(),
        onEditingComplete: onSaved,
        controller: _controller,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.message,
          enabled: widget.enabled,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton.filledTonal(
              onPressed: onSaved,
              icon: const Icon(Icons.send),
              // iconSize: 16,
              // visualDensity: VisualDensity.compact,
            ),
          ),
        ),
      ),
    );
  }
}
