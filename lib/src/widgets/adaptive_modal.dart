import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../platform/platform_info.dart';

class AdaptiveModal {
  // We don't need the MethodChannel for presentation anymore

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableBlur = true,
    Color? barrierColor,
  }) async {
    // 1. iOS 26+ Implementation
    // We use Flutter to manage the sheet lifecycle, but we inject the
    // Native View to get the actual "Liquid Glass" rendering.
    if (PlatformInfo.isIOS26OrHigher()) {
      return showModalBottomSheet<T>(
        context: context,
        // ✅ CRITICAL: This pushes the modal above the Native Tab Bar
        useRootNavigator: true,
        isDismissible: isDismissible,
        backgroundColor: Colors.transparent,
        barrierColor: barrierColor ?? Colors.black54,
        isScrollControlled: true,
        builder: (context) {
          // Wrap in a FractionallySizedBox or ConstrainedBox to control height
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Stack(
              children: [
                // Layer 1: The Swift Native Blur View
                const Positioned.fill(
                  child: UiKitView(
                    viewType: 'adaptive_platform_ui/ios26_modal',
                    // Pass unique ID if you follow your Slider pattern
                    creationParams: {
                      "id": 1,
                      "cornerRadius": 32.0,
                      "isDark": false,
                    },
                    creationParamsCodec: StandardMessageCodec(),
                  ),
                ),

                // Layer 2: Flutter Content
                SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // iOS 26 style Grabber
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          width: 36,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                      // The content from your builder (e.g., your Picker)
                      Flexible(child: builder(context)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // 2. Standard iOS implementation (Fallback)
    if (PlatformInfo.isIOS) {
      return showCupertinoModalPopup<T>(
        context: context,
        builder: builder,
        barrierDismissible: isDismissible,
        barrierColor: barrierColor ?? kCupertinoModalBarrierColor,
      );
    }

    // 3. Android/Default implementation
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
