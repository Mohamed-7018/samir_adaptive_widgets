import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../platform/platform_info.dart';

class AdaptiveCard extends StatelessWidget {
  const AdaptiveCard({
    super.key,
    this.color,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.semanticContainer = true,
    required this.child,
    this.padding,
    this.borderRadius,
  });
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final EdgeInsetsGeometry? margin;
  final Clip? clipBehavior;
  final bool semanticContainer;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    // iOS - Use custom iOS-style card
    if (PlatformInfo.isIOS) {
      return _IOSCard(
        color: color,
        margin: margin,
        clipBehavior: clipBehavior ?? Clip.none,
        semanticContainer: semanticContainer,
        borderRadius: borderRadius,
        child: content,
      );
    }

    // Android - Use Material Design Card
    if (PlatformInfo.isAndroid) {
      return Card(
        color: color,
        elevation: elevation,
        shape:
            shape ??
            (borderRadius != null
                ? RoundedRectangleBorder(borderRadius: borderRadius!)
                : null),
        borderOnForeground: borderOnForeground,
        margin: margin,
        clipBehavior: clipBehavior,
        semanticContainer: semanticContainer,
        child: content,
      );
    }

    // Fallback for other platforms (web, desktop, etc.)
    return Card(
      color: color,
      elevation: elevation,
      shape:
          shape ??
          (borderRadius != null
              ? RoundedRectangleBorder(borderRadius: borderRadius!)
              : null),
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: content,
    );
  }
}

class _IOSCard extends StatelessWidget {
  const _IOSCard({
    required this.color,
    required this.margin,
    required this.clipBehavior,
    required this.semanticContainer,
    required this.borderRadius,
    required this.child,
  });

  final Color? color;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;
  final bool semanticContainer;
  final BorderRadius? borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;

    // Default iOS card background color
    final backgroundColor =
        color ??
        (isDark ? CupertinoColors.darkBackgroundGray : CupertinoColors.white);

    // Default border radius
    final radius = borderRadius ?? BorderRadius.circular(12);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(
          color: isDark
              ? CupertinoColors.systemGrey6
              : CupertinoColors.separator,
          width: 0.5,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        clipBehavior: clipBehavior,
        child: semanticContainer
            ? Semantics(container: true, child: child)
            : child,
      ),
    );
  }
}
