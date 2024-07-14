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

  int get _extent => _value ?? widget.maxExtent;

  void _update(double val, bool notify) {
    setState(() {
      _value = val.toInt();
    });
    if (notify) {
      print('Notify');
      widget.onChanged(_value!);
    } else {
      print(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16.0);
    const sliderSteps = (300 - 60) ~/ 10;
    return ListTile(
      isThreeLine: true,
      title: const Padding(
        padding: padding,
        child: Text('Asset max width'),
      ),
      contentPadding: const EdgeInsets.all(0),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: padding,
            child: Text('The maximum size of thumbnails is the library.'
                '\nThumbnails may be smaller to prevent unused space, but will be no larger than this size.'),
          ),
          Slider(
            min: 60,
            max: 300,
            divisions: sliderSteps,
            label: _extent.toString(),
            value: _extent.toDouble(),
            onChanged: (v) => _update(v, false),
            onChangeEnd: (v) => _update(v, true),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final widgetCount = (constraints.maxWidth / _extent).ceil();
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
