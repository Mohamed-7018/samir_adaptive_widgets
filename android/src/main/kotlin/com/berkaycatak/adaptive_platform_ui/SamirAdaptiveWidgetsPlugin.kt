package com.berkaycatak.adaptive_platform_ui

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** AdaptivePlatformUiPlugin */
class SamirAdaptiveWidgetsPlugin: FlutterPlugin {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    // Android uses Material Design widgets directly in Dart
    // No platform views needed for Android
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
