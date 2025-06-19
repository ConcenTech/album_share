import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:titlebar_buttons/titlebar_buttons.dart';
import 'package:window_manager/window_manager.dart';

import '../logo_widget.dart';
import 'app_window.dart';

class DesktopWindowTitlebar extends StatelessWidget {
  const DesktopWindowTitlebar({
    this.showTitle = true,
    this.leading,
    this.header,
    this.titleBarIcons = const [],
    super.key,
  });

  final Widget? leading;

  final String? header;

  final List<Widget> titleBarIcons;

  /// If true, displays the app logo and name in the top bar.
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platform = theme.platform;
    assert(desktopPlatforms.contains(platform));

    if (platform == TargetPlatform.macOS) {
      return _CupertinoWindowTitlebar(
        showTitle: showTitle,
        titleBarIcons: titleBarIcons,
        leading: leading,
        header: header,
      );
    }

    return ColoredBox(
      color: (theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface)
          .withValues(alpha: 0.6),
      child: Row(
        children: [
          Expanded(
            child: MoveWindow(
              child: showTitle
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: SizedBox(
                            height: 16,
                            child: LogoImage(),
                          ),
                        ),
                        const SizedBox(width: 1),
                        if (leading != null) leading!,
                        if (header != null) Text(header!),
                      ],
                    )
                  : null,
            ),
          ),
          ...titleBarIcons,
          const MinimizeWindowButton(),
          const MaximizeWindowButton(),
          const CloseWindowButton(),
        ],
      ),
    );
  }
}

class _CupertinoWindowTitlebar extends StatelessWidget {
  const _CupertinoWindowTitlebar({
    required this.showTitle,
    required this.titleBarIcons,
    required this.leading,
    required this.header,
  });

  final bool showTitle;
  final List<Widget> titleBarIcons;
  final Widget? leading;
  final String? header;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CupertinoTheme.of(context).barBackgroundColor,
      child: Row(
        children: [
          const SizedBox(width: 65),
          if (leading != null) leading!,
          Expanded(
            child: MoveWindow(
              child: Center(
                child: header == null ? const SizedBox() : Text(header!),
              ),
            ),
          ),
          ...titleBarIcons,
          if (showTitle)
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: SizedBox(
                height: 16,
                child: LogoImage(),
              ),
            ),
        ],
      ),
    );
  }
}

class MoveWindow extends StatelessWidget {
  const MoveWindow({
    required this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => AppWindow.maximiseOrRestore(),
      onPanStart: (_) => windowManager.startDragging(),
      child: ColoredBox(color: Colors.transparent, child: child),
    );
  }
}

class MinimizeWindowButton extends StatelessWidget {
  const MinimizeWindowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedMinimizeButton(
      onPressed: () => windowManager.minimize(),
    );
  }
}

class MaximizeWindowButton extends StatelessWidget {
  const MaximizeWindowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedMaximizeButton(
      onPressed: () => AppWindow.maximiseOrRestore(),
    );
  }
}

class CloseWindowButton extends StatelessWidget {
  const CloseWindowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedCloseButton(
      onPressed: () => windowManager.close(),
    );
  }
}
