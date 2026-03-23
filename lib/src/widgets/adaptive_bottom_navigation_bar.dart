import 'package:flutter/cupertino.dart';
import 'adaptive_scaffold.dart';

class AdaptiveBottomNavigationBar {
  const AdaptiveBottomNavigationBar({
    this.items,
    this.selectedIndex,
    this.onTap,
    this.useNativeBottomBar = true,
    this.cupertinoTabBar,
    this.bottomNavigationBar,
    this.selectedItemColor,
    this.unselectedItemColor,
  });
  final List<AdaptiveNavigationDestination>? items;
  final int? selectedIndex;
  final ValueChanged<int>? onTap;
  final bool useNativeBottomBar;
  final CupertinoTabBar? cupertinoTabBar;
  final Widget? bottomNavigationBar;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  AdaptiveBottomNavigationBar copyWith({
    List<AdaptiveNavigationDestination>? items,
    int? selectedIndex,
    ValueChanged<int>? onTap,
    bool? useNativeBottomBar,
    CupertinoTabBar? cupertinoTabBar,
    Widget? bottomNavigationBar,
    Color? selectedItemColor,
    Color? unselectedItemColor,
  }) {
    return AdaptiveBottomNavigationBar(
      items: items ?? this.items,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      onTap: onTap ?? this.onTap,
      useNativeBottomBar: useNativeBottomBar ?? this.useNativeBottomBar,
      cupertinoTabBar: cupertinoTabBar ?? this.cupertinoTabBar,
      bottomNavigationBar: bottomNavigationBar ?? this.bottomNavigationBar,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
    );
  }
}
