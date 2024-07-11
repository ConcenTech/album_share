import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/library/library_providers.dart';
import '../../utils/extension_methods.dart';

class RefreshButton extends ConsumerStatefulWidget {
  const RefreshButton({super.key});

  @override
  ConsumerState<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends ConsumerState<RefreshButton> {
  Timer? _timer;
  _Status _status = _Status.ready;

  void _refresh() async {
    _setStatus(_Status.refreshing);
    await ref.read(LibraryProviders.assets.notifier).update();
    await Future.delayed(2.seconds);
    _setStatus(_Status.timeout);
    if (_timer?.isActive ?? false) {
      return;
    }
    _timer = Timer(1.minutes, () {
      _setStatus(_Status.ready);
    });
  }

  void _setStatus(_Status status) {
    if (mounted) {
      setState(() {
        _status = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _status == _Status.refreshing
          ? const SizedBox(
              width: 16,
              height: 10,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
          : const Icon(Icons.refresh),
      onPressed: _status == _Status.ready ? _refresh : null,
      iconSize: 18,
      style: IconButton.styleFrom(
        minimumSize: const Size(25, 25),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}

enum _Status {
  ready,
  refreshing,
  timeout,
}
