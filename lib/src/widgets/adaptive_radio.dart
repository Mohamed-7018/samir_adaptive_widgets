import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../platform/platform_info.dart';

class AdaptiveRadio<T> extends StatelessWidget {
  const AdaptiveRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.activeColor,
    this.focusColor,
    this.hoverColor,
    this.toggleable = false,
  });
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Color? activeColor;
  final Color? focusColor;
  final Color? hoverColor;
  final bool toggleable;

  @override
  Widget build(BuildContext context) {
    // iOS - Use custom iOS-style radio
    if (PlatformInfo.isIOS) {
      return _IOSRadio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: activeColor ?? CupertinoTheme.of(context).primaryColor,
        toggleable: toggleable,
      );
    }

    // Android - Use Material Design Radio
    if (PlatformInfo.isAndroid) {
      // ignore: deprecated_member_use
      return Radio<T>(
        value: value,
        // ignore: deprecated_member_use
        groupValue: groupValue,
        // ignore: deprecated_member_use
        onChanged: onChanged,
        activeColor: activeColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        toggleable: toggleable,
      );
    }

    // Fallback for other platforms (web, desktop, etc.)
    // ignore: deprecated_member_use
    return Radio<T>(
      value: value,
      // ignore: deprecated_member_use
      groupValue: groupValue,
      // ignore: deprecated_member_use
      onChanged: onChanged,
      activeColor: activeColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      toggleable: toggleable,
    );
  }
}

class _IOSRadio<T> extends StatelessWidget {
  const _IOSRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.activeColor,
    required this.toggleable,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Color activeColor;
  final bool toggleable;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: onChanged == null
          ? null
          : () {
              if (toggleable && _selected) {
                onChanged!(null);
              } else if (!_selected) {
                onChanged!(value);
              }
            },
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _selected
              ? activeColor
              : (isDark
                    ? CupertinoColors.systemGrey5.darkColor
                    : CupertinoColors.systemBackground.color),
          border: Border.all(
            color: _selected
                ? activeColor
                : (isDark
                      ? CupertinoColors.systemGrey3.darkColor
                      : CupertinoColors.systemGrey4.color),
            width: _selected ? 6 : 1.5,
          ),
        ),
      ),
    );
  }
}
