import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../platform/platform_info.dart';
import 'ios26/ios26_slider.dart';

class AdaptiveSlider extends StatelessWidget {
  const AdaptiveSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.thumbColor,
  });
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? thumbColor;

  @override
  Widget build(BuildContext context) {
    // iOS 26+ - Use native iOS 26 slider
    if (PlatformInfo.isIOS26OrHigher()) {
      return IOS26Slider(
        value: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        activeColor: activeColor,
        thumbColor: thumbColor,
      );
    }

    // iOS 18 and below - Use traditional CupertinoSlider
    if (PlatformInfo.isIOS) {
      return CupertinoSlider(
        value: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        activeColor: activeColor,
        thumbColor: thumbColor ?? CupertinoColors.white,
      );
    }

    // Android - Use Material Design Slider
    if (PlatformInfo.isAndroid) {
      return Slider(
        value: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        activeColor: activeColor,
        thumbColor: thumbColor,
      );
    }

    // Fallback for other platforms (web, desktop, etc.)
    return Slider(
      value: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
      activeColor: activeColor,
      thumbColor: thumbColor,
    );
  }
}
