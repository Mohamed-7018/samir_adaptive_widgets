import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

class IOS26Slider extends StatefulWidget {
  const IOS26Slider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.activeColor,
    this.thumbColor,
  });
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final Color? activeColor;
  final Color? thumbColor;

  @override
  State<IOS26Slider> createState() => _IOS26SliderState();
}

class _IOS26SliderState extends State<IOS26Slider> {
  static int _nextId = 0;
  late final int _id;
  late final MethodChannel _channel;

  @override
  void initState() {
    super.initState();
    _id = _nextId++;
    _channel = MethodChannel('adaptive_platform_ui/ios26_slider_$_id');
    _channel.setMethodCallHandler(_handleMethod);
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'valueChanged':
        final value = call.arguments['value'] as double;
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
        break;
      case 'changeStart':
        final value = call.arguments['value'] as double;
        if (widget.onChangeStart != null) {
          widget.onChangeStart!(value);
        }
        break;
      case 'changeEnd':
        final value = call.arguments['value'] as double;
        if (widget.onChangeEnd != null) {
          widget.onChangeEnd!(value);
        }
        break;
    }
  }

  @override
  void didUpdateWidget(IOS26Slider oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update native side if properties changed
    if (oldWidget.value != widget.value) {
      _channel.invokeMethod('setValue', {'value': widget.value});
    }

    if (oldWidget.min != widget.min || oldWidget.max != widget.max) {
      _channel.invokeMethod('setRange', {'min': widget.min, 'max': widget.max});
    }

    if (oldWidget.activeColor != widget.activeColor &&
        widget.activeColor != null) {
      _channel.invokeMethod('setActiveColor', {
        'color': _colorToARGB(widget.activeColor!),
      });
    }

    if (oldWidget.thumbColor != widget.thumbColor &&
        widget.thumbColor != null) {
      _channel.invokeMethod('setThumbColor', {
        'color': _colorToARGB(widget.thumbColor!),
      });
    }

    // Update enabled state
    if ((oldWidget.onChanged == null) != (widget.onChanged == null)) {
      _channel.invokeMethod('setEnabled', {
        'enabled': widget.onChanged != null,
      });
    }
  }

  Map<String, dynamic> _buildCreationParams() {
    return {
      'id': _id,
      'value': widget.value,
      'min': widget.min,
      'max': widget.max,
      'enabled': widget.onChanged != null,
      if (widget.activeColor != null)
        'activeColor': _colorToARGB(widget.activeColor!),
      if (widget.thumbColor != null)
        'thumbColor': _colorToARGB(widget.thumbColor!),
      'isDark': MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
  }

  int _colorToARGB(Color color) {
    return (((color.a * 255.0).round() & 0xFF) << 24) |
        (((color.r * 255.0).round() & 0xFF) << 16) |
        (((color.g * 255.0).round() & 0xFF) << 8) |
        ((color.b * 255.0).round() & 0xFF);
  }

  @override
  Widget build(BuildContext context) {
    // Only use native implementation on iOS
    if (!kIsWeb && Platform.isIOS) {
      final platformView = UiKitView(
        viewType: 'adaptive_platform_ui/ios26_slider',
        creationParams: _buildCreationParams(),
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer(),
          ),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
        },
      );

      return SizedBox(
        height: 31, // Standard iOS slider height
        child: platformView,
      );
    }

    // Fallback to CupertinoSlider on other platforms
    return CupertinoSlider(
      value: widget.value,
      onChanged: widget.onChanged,
      onChangeStart: widget.onChangeStart,
      onChangeEnd: widget.onChangeEnd,
      min: widget.min,
      max: widget.max,
      activeColor: widget.activeColor,
      thumbColor: widget.thumbColor ?? CupertinoColors.white,
    );
  }
}
