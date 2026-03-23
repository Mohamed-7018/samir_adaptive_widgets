import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../platform/platform_info.dart';

class AdaptiveCheckbox extends StatelessWidget {
  const AdaptiveCheckbox({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
  });
  final bool? value;
  final bool tristate;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;

  @override
  Widget build(BuildContext context) {
    // iOS - Use custom iOS-style checkbox
    if (PlatformInfo.isIOS) {
      return _IOSCheckbox(
        value: value,
        tristate: tristate,
        onChanged: onChanged,
        activeColor: activeColor ?? CupertinoTheme.of(context).primaryColor,
        checkColor: checkColor,
      );
    }

    // Android - Use Material Design Checkbox
    if (PlatformInfo.isAndroid) {
      return Checkbox(
        value: value,
        tristate: tristate,
        onChanged: onChanged,
        activeColor: activeColor,
        checkColor: checkColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
      );
    }

    // Fallback for other platforms (web, desktop, etc.)
    return Checkbox(
      value: value,
      tristate: tristate,
      onChanged: onChanged,
      activeColor: activeColor,
      checkColor: checkColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
    );
  }
}

class _IOSCheckbox extends StatelessWidget {
  const _IOSCheckbox({
    required this.value,
    required this.tristate,
    required this.onChanged,
    required this.activeColor,
    this.checkColor,
  });

  final bool? value;
  final bool tristate;
  final ValueChanged<bool?>? onChanged;
  final Color activeColor;
  final Color? checkColor;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final effectiveCheckColor = checkColor ?? CupertinoColors.white;
    final backgroundColor = isDark
        ? CupertinoColors.systemGrey5.darkColor
        : CupertinoColors.systemBackground.color;
    final borderColor = isDark
        ? CupertinoColors.systemGrey3.darkColor
        : CupertinoColors.systemGrey4.color;

    return GestureDetector(
      onTap: onChanged == null
          ? null
          : () {
              if (tristate) {
                // Cycle: false -> true -> null -> false
                if (value == false) {
                  onChanged!(true);
                } else if (value == true) {
                  onChanged!(null);
                } else {
                  onChanged!(false);
                }
              } else {
                onChanged!(!(value ?? false));
              }
            },
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: value == true ? activeColor : backgroundColor,
          border: Border.all(
            color: value == true ? activeColor : borderColor,
            width: value == true ? 0 : 1.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: value == true
            ? Icon(
                CupertinoIcons.checkmark,
                size: 14,
                color: effectiveCheckColor,
              )
            : value == null
            ? Center(
                child: Container(
                  width: 8,
                  height: 2,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
