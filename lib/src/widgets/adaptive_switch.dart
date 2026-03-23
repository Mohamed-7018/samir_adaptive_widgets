import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../platform/platform_info.dart';
import 'ios26/ios26_switch.dart';

class AdaptiveSwitch extends StatelessWidget {
  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.thumbColor,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? thumbColor;

  @override
  Widget build(BuildContext context) {
    // iOS 26+ - Use native iOS 26 switch
    if (PlatformInfo.isIOS26OrHigher()) {
      return IOS26Switch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        thumbColor: thumbColor,
      );
    }

    // iOS 18 and below - Use traditional CupertinoSwitch
    if (PlatformInfo.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor:
            activeColor ?? CupertinoTheme.of(context).primaryColor,
        thumbColor: thumbColor,
      );
    }

    // Android - Use Material Design Switch
    if (PlatformInfo.isAndroid) {
      return Switch(
        value: value,
        onChanged: onChanged,
        thumbColor: thumbColor != null
            ? WidgetStateProperty.all(thumbColor)
            : null,
        trackColor: activeColor != null
            ? WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return activeColor;
                }
                return null;
              })
            : null,
      );
    }

    // Fallback for other platforms (web, desktop, etc.)
    return Switch(
      value: value,
      onChanged: onChanged,
      thumbColor: thumbColor != null
          ? WidgetStateProperty.all(thumbColor)
          : null,
      trackColor: activeColor != null
          ? WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return activeColor;
              }
              return null;
            })
          : null,
    );
  }
}
