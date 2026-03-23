import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../platform/platform_info.dart';

class AdaptiveFloatingActionButton extends StatelessWidget {
  const AdaptiveFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.mini = false,
    this.tooltip,
    this.heroTag,
  });
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool mini;
  final String? tooltip;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    // iOS implementation
    if (PlatformInfo.isIOS) {
      return _buildIOSButton(context);
    }

    // Android - Use Material FloatingActionButton
    if (PlatformInfo.isAndroid) {
      return _buildMaterialFAB(context);
    }

    // Fallback to Material
    return _buildMaterialFAB(context);
  }

  Widget _buildIOSButton(BuildContext context) {
    final defaultBackgroundColor =
        backgroundColor ?? CupertinoTheme.of(context).primaryColor;
    final defaultForegroundColor = foregroundColor ?? CupertinoColors.white;
    final buttonSize = mini ? 40.0 : 56.0;
    final iconSize = mini ? 20.0 : 24.0;
    final shadowElevation = elevation ?? 6.0;

    Widget button = Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: shadowElevation * 1.5,
            offset: Offset(0, shadowElevation / 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: IconTheme(
          data: IconThemeData(color: defaultForegroundColor, size: iconSize),
          child: child,
        ),
      ),
    );

    // Wrap with hero if tag is provided
    if (heroTag != null) {
      button = Hero(tag: heroTag!, child: button);
    }

    return button;
  }

  Widget _buildMaterialFAB(BuildContext context) {
    Widget fab;

    if (mini) {
      fab = FloatingActionButton.small(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
        tooltip: tooltip,
        heroTag: heroTag,
        child: child,
      );
    } else {
      fab = FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
        tooltip: tooltip,
        heroTag: heroTag,
        child: child,
      );
    }

    return fab;
  }
}
