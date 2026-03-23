import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../platform/platform_info.dart';

class AdaptiveListTile extends StatelessWidget {
  const AdaptiveListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.backgroundColor,
    this.padding,
  });
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool selected;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (PlatformInfo.isIOS) {
      return _buildCupertinoListTile(context);
    }

    // Android - Use Material ListTile
    return _buildMaterialListTile(context);
  }

  Widget _buildCupertinoListTile(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    Widget child = Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (selected
                ? (isDark
                      ? CupertinoColors.systemGrey5.darkColor
                      : CupertinoColors.systemGrey6.color)
                : (isDark
                      ? CupertinoColors.darkBackgroundGray
                      : CupertinoColors.white)),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? CupertinoColors.systemGrey4
                : CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: enabled
                          ? (isDark
                                ? CupertinoColors.white
                                : CupertinoColors.black)
                          : (isDark
                                ? CupertinoColors.systemGrey
                                : CupertinoColors.systemGrey2),
                    ),
                    child: title!,
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? CupertinoColors.systemGrey
                          : CupertinoColors.systemGrey2,
                    ),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );

    if (enabled && (onTap != null || onLongPress != null)) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: child,
      );
    }

    return child;
  }

  Widget _buildMaterialListTile(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      enabled: enabled,
      selected: selected,
      tileColor: backgroundColor,
      contentPadding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
