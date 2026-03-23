import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../platform/platform_info.dart';

class AdaptiveContextMenuAction {
  const AdaptiveContextMenuAction({
    required this.title,
    required this.onPressed,
    this.icon,
    this.isDestructive = false,
    this.isDisabled = false,
  });
  final String title;
  final VoidCallback onPressed;
  final dynamic icon;
  final bool isDestructive;
  final bool isDisabled;
}

class AdaptiveContextMenu extends StatelessWidget {
  const AdaptiveContextMenu({
    super.key,
    required this.child,
    required this.actions,
    this.previewBuilder,
  });
  final Widget child;
  final List<AdaptiveContextMenuAction> actions;
  final Widget Function(BuildContext)? previewBuilder;

  @override
  Widget build(BuildContext context) {
    // iOS 26+ - Use CupertinoContextMenu
    // Note: Native iOS 26 UIContextMenu could be implemented with platform view for enhanced visuals
    if (PlatformInfo.isIOS26OrHigher()) {
      return _buildCupertinoContextMenu(context);
    }

    // iOS <26 - Use CupertinoContextMenu
    if (PlatformInfo.isIOS) {
      return _buildCupertinoContextMenu(context);
    }

    // Android - Use PopupMenuButton
    return _buildAndroidContextMenu(context);
  }

  Widget _buildCupertinoContextMenu(BuildContext context) {
    return CupertinoContextMenu.builder(
      actions: actions.map((action) {
        return CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Future.microtask(() => action.onPressed());
          },
          isDestructiveAction: action.isDestructive,
          trailingIcon: action.icon is IconData
              ? action.icon as IconData
              : null,
          child: Text(action.title),
        );
      }).toList(),
      builder: (context, animation) {
        return child;
      },
    );
  }

  Widget _buildAndroidContextMenu(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showAndroidMenu(context);
      },
      child: child,
    );
  }

  void _showAndroidMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy,
      ),
      items: actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;

        return PopupMenuItem<int>(
          value: index,
          enabled: !action.isDisabled,
          child: Row(
            children: [
              if (action.icon != null && action.icon is IconData) ...[
                Icon(
                  action.icon as IconData,
                  size: 20,
                  color: action.isDestructive
                      ? Colors.red
                      : (action.isDisabled ? Colors.grey : null),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  action.title,
                  style: TextStyle(
                    color: action.isDestructive
                        ? Colors.red
                        : (action.isDisabled ? Colors.grey : null),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ).then((selectedIndex) {
      if (selectedIndex != null) {
        actions[selectedIndex].onPressed();
      }
    });
  }
}
