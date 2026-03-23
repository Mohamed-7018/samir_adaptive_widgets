import 'package:flutter/services.dart';

class IOS26NativeSearchTabBar {
  static const MethodChannel _channel = MethodChannel(
    'adaptive_platform_ui/native_tab_bar',
  );

  static bool _isEnabled = false;
  static Future<void> enable({
    required List<NativeTabConfig> tabs,
    int selectedIndex = 0,
    void Function(int index)? onTabSelected,
    void Function(String query)? onSearchQueryChanged,
    void Function(String query)? onSearchSubmitted,
    VoidCallback? onSearchCancelled,
  }) async {
    if (_isEnabled) {
      return;
    }

    // Setup method call handler for callbacks
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onTabSelected':
          final index = call.arguments['index'] as int;
          onTabSelected?.call(index);
          break;
        case 'onSearchQueryChanged':
          final query = call.arguments['query'] as String;
          onSearchQueryChanged?.call(query);
          break;
        case 'onSearchSubmitted':
          final query = call.arguments['query'] as String;
          onSearchSubmitted?.call(query);
          break;
        case 'onSearchCancelled':
          onSearchCancelled?.call();
          break;
      }
    });

    // Enable native tab bar
    await _channel.invokeMethod('enableNativeTabBar', {
      'tabs': tabs
          .map(
            (tab) => {
              'title': tab.title,
              'sfSymbol': tab.sfSymbol,
              'isSearch': tab.isSearchTab,
            },
          )
          .toList(),
      'selectedIndex': selectedIndex,
    });

    _isEnabled = true;
  }

  static Future<void> disable() async {
    if (!_isEnabled) {
      return;
    }

    await _channel.invokeMethod('disableNativeTabBar');
    _isEnabled = false;
  }

  static Future<void> setSelectedIndex(int index) async {
    await _channel.invokeMethod('setSelectedIndex', {'index': index});
  }

  static Future<void> showSearch() async {
    await _channel.invokeMethod('showSearch');
  }

  static Future<void> hideSearch() async {
    await _channel.invokeMethod('hideSearch');
  }

  static Future<bool> isEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('isEnabled');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
}

class NativeTabConfig {
  final String title;
  final String? sfSymbol;
  final bool isSearchTab;

  const NativeTabConfig({
    required this.title,
    this.sfSymbol,
    this.isSearchTab = false,
  });
}
