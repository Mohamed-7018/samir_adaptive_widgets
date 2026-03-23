import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformInfo {
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  static bool get isWindows => !kIsWeb && Platform.isWindows;

  static bool get isLinux => !kIsWeb && Platform.isLinux;

  static bool get isFuchsia => !kIsWeb && Platform.isFuchsia;

  static bool get isWeb => kIsWeb;

  
  static int get iOSVersion {
    if (!isIOS) return 0;

    try {
      final version = Platform.operatingSystemVersion;
      final match = RegExp(r'Version (\d+)').firstMatch(version);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
      final fallbackMatch = RegExp(r'(\d+)').firstMatch(version);
      if (fallbackMatch != null) {
        return int.parse(fallbackMatch.group(1)!);
      }
    } catch (e) {
      debugPrint('Error parsing iOS version: $e');
    }

    return 0;
  }


  static bool isIOS26OrHigher() {
    return isIOS && iOSVersion >= 26;
  }


  static bool isIOS18OrLower() {
    return isIOS && iOSVersion > 0 && iOSVersion < 26;
  }

  static bool isIOSVersionInRange(int min, int max) {
    return isIOS && iOSVersion >= min && iOSVersion <= max;
  }

  static String get platformDescription {
    if (isIOS) return 'iOS $iOSVersion';
    if (isAndroid) return 'Android';
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    if (isFuchsia) return 'Fuchsia';
    if (isWeb) return 'Web';
    return 'Unknown';
  }
}
