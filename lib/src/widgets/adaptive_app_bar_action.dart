import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ToolbarSpacerType { none, fixed, flexible }

class AdaptiveAppBarAction {
  const AdaptiveAppBarAction({
    this.iosSymbol,
    this.icon,
    this.title,
    required this.onPressed,
    this.spacerAfter = ToolbarSpacerType.none,
  }) : assert(
         iosSymbol != null || icon != null || title != null,
         'At least one of iosSymbol, icon, or title must be provided',
       );
  final String? iosSymbol;
  final IconData? icon;
  final String? title;
  final VoidCallback onPressed;
  final ToolbarSpacerType spacerAfter;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdaptiveAppBarAction &&
        other.iosSymbol == iosSymbol &&
        other.icon == icon &&
        other.title == title;
  }

  @override
  int get hashCode => Object.hash(iosSymbol, icon, title);
  Map<String, dynamic> toNativeMap() {
    return {
      if (iosSymbol != null) 'icon': iosSymbol!,
      if (title != null) 'title': title!,
      'spacerAfter': spacerAfter.index, // 0=none, 1=fixed, 2=flexible
    };
  }
}
