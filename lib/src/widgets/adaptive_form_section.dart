import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../samir_adaptive_widgets.dart';

class AdaptiveFormSection extends StatelessWidget {
  const AdaptiveFormSection({
    super.key,
    required this.children,
    this.header,
    this.footer,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.decoration,
    this.clipBehavior = Clip.none,
  }) : insetGrouped = false;
  const AdaptiveFormSection.insetGrouped({
    super.key,
    required this.children,
    this.header,
    this.footer,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.backgroundColor,
    this.decoration,
    this.clipBehavior = Clip.hardEdge,
  }) : insetGrouped = true;
  final List<Widget> children;
  final Widget? header;
  final Widget? footer;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final Clip clipBehavior;
  final bool insetGrouped;

  @override
  Widget build(BuildContext context) {
    if (PlatformInfo.isIOS) {
      return _buildIOSFormSection(context);
    }
    if (PlatformInfo.isAndroid) {
      return _buildMaterialFormSection(context);
    }
    return _buildMaterialFormSection(context);
  }

  Widget _buildIOSFormSection(BuildContext context) {
    // CupertinoFormSection requires non-nullable backgroundColor
    final Color effectiveBackgroundColor =
        backgroundColor ?? CupertinoColors.systemGroupedBackground;

    if (insetGrouped) {
      return CupertinoFormSection.insetGrouped(
        header: header,
        footer: footer,
        margin: margin,
        backgroundColor: effectiveBackgroundColor,
        decoration: decoration,
        clipBehavior: clipBehavior,
        children: children,
      );
    }

    return CupertinoFormSection(
      header: header,
      footer: footer,
      margin: margin,
      backgroundColor: effectiveBackgroundColor,
      decoration: decoration,
      clipBehavior: clipBehavior,
      children: children,
    );
  }

  Widget _buildMaterialFormSection(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = backgroundColor ?? theme.cardColor;

    // Build header widget
    Widget? headerWidget;
    if (header != null) {
      headerWidget = DefaultTextStyle(
        style:
            theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ) ??
            TextStyle(
              fontSize: 14,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          child: header!,
        ),
      );
    }

    // Build footer widget
    Widget? footerWidget;
    if (footer != null) {
      footerWidget = DefaultTextStyle(
        style:
            theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ) ??
            TextStyle(
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          child: footer!,
        ),
      );
    }

    // Build the card content
    Widget cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    // Apply decoration or default styling
    final BoxDecoration finalDecoration =
        decoration ??
        BoxDecoration(
          color: defaultBackgroundColor,
          borderRadius: insetGrouped ? BorderRadius.circular(12.0) : null,
        );

    Widget section = Container(
      decoration: finalDecoration,
      clipBehavior: clipBehavior,
      child: cardContent,
    );

    // Add elevation for Material design
    if (insetGrouped) {
      section = Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: clipBehavior,
        color: defaultBackgroundColor,
        child: cardContent,
      );
    } else {
      section = Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
        clipBehavior: clipBehavior,
        color: defaultBackgroundColor,
        child: cardContent,
      );
    }

    // Wrap with margin
    section = Padding(padding: margin, child: section);

    // Add header and footer if present
    if (header != null || footer != null) {
      section = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (headerWidget != null) headerWidget,
          section,
          if (footerWidget != null) footerWidget,
        ],
      );
    }

    return section;
  }
}
