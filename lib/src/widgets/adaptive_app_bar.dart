import 'package:flutter/widgets.dart';
import 'adaptive_app_bar_action.dart';

class AdaptiveAppBar {
  const AdaptiveAppBar({
    this.title,
    this.actions,
    this.leading,
    this.useNativeToolbar = true,
    this.cupertinoNavigationBar,
    this.appBar,
  });
  final String? title;
  final List<AdaptiveAppBarAction>? actions;
  final Widget? leading;
  final bool useNativeToolbar;
  final PreferredSizeWidget? cupertinoNavigationBar;
  final PreferredSizeWidget? appBar;
  AdaptiveAppBar copyWith({
    String? title,
    List<AdaptiveAppBarAction>? actions,
    Widget? leading,
    bool? useNativeToolbar,
    PreferredSizeWidget? cupertinoNavigationBar,
    PreferredSizeWidget? appBar,
  }) {
    return AdaptiveAppBar(
      title: title ?? this.title,
      actions: actions ?? this.actions,
      leading: leading ?? this.leading,
      useNativeToolbar: useNativeToolbar ?? this.useNativeToolbar,
      cupertinoNavigationBar:
          cupertinoNavigationBar ?? this.cupertinoNavigationBar,
      appBar: appBar ?? this.appBar,
    );
  }
}
