import 'package:album_share/immich/asset_grid/thumbnail_placeholder.dart';
import 'package:flutter/material.dart';

class MaxExtentWidget extends StatefulWidget {
  const MaxExtentWidget({
    required this.maxExtent,
    required this.onChanged,
    super.key,
  });

  final int maxExtent;
  final void Function(int v) onChanged;

  @override
  State<MaxExtentWidget> createState() => _MaxExtentWidgetState();
}

class _MaxExtentWidgetState extends State<MaxExtentWidget> {
  int? _value;

  void _update(double val, bool notify) {
    setState(() {
      _value = val.toInt();
    });
    if (notify) {
      print('Notify');
      widget.onChanged(_value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: const Text('Asset max width'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Describe what this does.'),
          Slider(
            min: 5,
            max: 500,
            value: (_value ?? widget.maxExtent).toDouble(),
            onChanged: (v) => _update(v, false),
            onChangeEnd: (v) => _update(v, true),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final widgetCount =
                  (constraints.maxWidth / widget.maxExtent).ceil();
              final size = constraints.maxWidth / widgetCount;
              return Row(
                children: List.filled(
                  widgetCount,
                  SizedBox(
                    width: size,
                    height: size,
                    child: const Padding(
                      padding: const EdgeInsets.all(2),
                      child: ColoredBox(color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
