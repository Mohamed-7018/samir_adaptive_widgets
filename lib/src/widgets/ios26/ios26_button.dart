import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../style/sf_symbol.dart';

enum IOS26ButtonStyle {
  filled,
  tinted,
  gray,
  bordered,
  plain,
  glass,
  prominentGlass,
}

enum IOS26ButtonSize { small, medium, large }

class IOS26Button extends StatefulWidget {
  const IOS26Button({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = IOS26ButtonStyle.filled,
    this.size = IOS26ButtonSize.medium,
    this.color,
    this.textColor,
    this.enabled = true,
    this.padding,
    this.borderRadius,
    this.minSize,
    this.useSmoothRectangleBorder = true,
  }) : child = null,
       isChildMode = false,
       sfSymbol = null;

  const IOS26Button.child({
    super.key,
    required this.onPressed,
    required this.child,
    this.style = IOS26ButtonStyle.filled,
    this.size = IOS26ButtonSize.medium,
    this.color,
    this.enabled = true,
    this.padding,
    this.borderRadius,
    this.minSize,
    this.useSmoothRectangleBorder = true,
  }) : label = '',
       textColor = null,
       isChildMode = true,
       sfSymbol = null;

  const IOS26Button.sfSymbol({
    super.key,
    required this.onPressed,
    required this.sfSymbol,
    this.style = IOS26ButtonStyle.glass,
    this.size = IOS26ButtonSize.medium,
    this.color,
    this.enabled = true,
    this.padding,
    this.borderRadius,
    this.minSize,
    this.useSmoothRectangleBorder = true,
  }) : label = '',
       textColor = null,
       child = null,
       isChildMode = false;

  final VoidCallback? onPressed;

  final String label;
  final Widget? child;

  final SFSymbol? sfSymbol;

  final bool isChildMode;

  final IOS26ButtonStyle style;

  final IOS26ButtonSize size;

  final Color? color;
  final Color? textColor;

  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  final Size? minSize;

  final bool useSmoothRectangleBorder;

  @override
  State<IOS26Button> createState() => _IOS26ButtonState();
}

class _IOS26ButtonState extends State<IOS26Button> {
  static int _nextId = 0;
  late final int _id;
  late final MethodChannel _channel;

  @override
  void initState() {
    super.initState();
    _id = _nextId++;
    _channel = MethodChannel('adaptive_platform_ui/ios26_button_$_id');
    _channel.setMethodCallHandler(_handleMethod);
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'pressed':
        if (widget.enabled && widget.onPressed != null) {
          widget.onPressed!();
        }
        break;
    }
  }

  @override
  void didUpdateWidget(IOS26Button oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update native side if properties changed
    if (oldWidget.style != widget.style) {
      _channel.invokeMethod('setStyle', {
        'style': _styleToString(widget.style),
      });
    }

    if (oldWidget.enabled != widget.enabled) {
      _channel.invokeMethod('setEnabled', {
        'enabled': widget.enabled && widget.onPressed != null,
      });
    }

    if (oldWidget.label != widget.label) {
      _channel.invokeMethod('setLabel', {'label': widget.label});
    }

    if (oldWidget.color != widget.color) {
      _channel.invokeMethod('setColor', {
        'color': widget.color != null ? _colorToHex(widget.color!) : null,
      });
    }

    if (oldWidget.useSmoothRectangleBorder != widget.useSmoothRectangleBorder) {
      _channel.invokeMethod('setUseSmoothRectangleBorder', {
        'useSmoothRectangleBorder': widget.useSmoothRectangleBorder,
      });
    }

    // Update SF Symbol if changed
    if (oldWidget.sfSymbol?.name != widget.sfSymbol?.name ||
        oldWidget.sfSymbol?.size != widget.sfSymbol?.size ||
        oldWidget.sfSymbol?.color != widget.sfSymbol?.color) {
      if (widget.sfSymbol != null) {
        _channel.invokeMethod('setIcon', {
          'iconName': widget.sfSymbol!.name,
          'iconSize': widget.sfSymbol!.size,
          if (widget.sfSymbol!.color != null)
            'iconColor': _colorToARGB(widget.sfSymbol!.color!),
        });
      }
    }
  }

  Map<String, dynamic> _buildCreationParams() {
    return {
      'id': _id,
      'label': widget.label,
      'style': _styleToString(widget.style),
      'size': _sizeToString(widget.size),
      'enabled': widget.enabled && widget.onPressed != null,
      'color': widget.color != null ? _colorToHex(widget.color!) : null,
      'textColor': widget.textColor != null
          ? _colorToHex(widget.textColor!)
          : null,
      'isDark': MediaQuery.platformBrightnessOf(context) == Brightness.dark,
      'useSmoothRectangleBorder': widget.useSmoothRectangleBorder,
      if (widget.sfSymbol != null) 'iconName': widget.sfSymbol!.name,
      if (widget.sfSymbol != null) 'iconSize': widget.sfSymbol!.size,
      if (widget.sfSymbol?.color != null)
        'iconColor': _colorToARGB(widget.sfSymbol!.color!),
    };
  }

  String _styleToString(IOS26ButtonStyle style) {
    switch (style) {
      case IOS26ButtonStyle.filled:
        return 'filled';
      case IOS26ButtonStyle.tinted:
        return 'tinted';
      case IOS26ButtonStyle.gray:
        return 'gray';
      case IOS26ButtonStyle.bordered:
        return 'bordered';
      case IOS26ButtonStyle.plain:
        return 'plain';
      case IOS26ButtonStyle.glass:
        return 'glass';
      case IOS26ButtonStyle.prominentGlass:
        return 'prominentGlass';
    }
  }

  String _sizeToString(IOS26ButtonSize size) {
    switch (size) {
      case IOS26ButtonSize.small:
        return 'small';
      case IOS26ButtonSize.medium:
        return 'medium';
      case IOS26ButtonSize.large:
        return 'large';
    }
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  int _colorToARGB(Color color) {
    return (((color.a * 255.0).round() & 0xFF) << 24) |
        (((color.r * 255.0).round() & 0xFF) << 16) |
        (((color.g * 255.0).round() & 0xFF) << 8) |
        ((color.b * 255.0).round() & 0xFF);
  }

  double get _height {
    switch (widget.size) {
      case IOS26ButtonSize.small:
        return 28.0;
      case IOS26ButtonSize.medium:
        return 36.0;
      case IOS26ButtonSize.large:
        return 44.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only use native implementation on iOS
    if (!kIsWeb && Platform.isIOS) {
      final platformView = UiKitView(
        viewType: 'adaptive_platform_ui/ios26_button',
        creationParams: _buildCreationParams(),
        creationParamsCodec: const StandardMessageCodec(),
      );

      // Wrap in SizedBox for height constraint
      Widget buttonWidget = SizedBox(
        height: _height,
        child: widget.isChildMode
            ? Stack(
                children: [
                  Positioned.fill(child: platformView),
                  Center(child: IgnorePointer(child: widget.child!)),
                ],
              )
            : platformView,
      );

      // Apply width constraint if minSize is provided
      if (widget.minSize != null) {
        buttonWidget = SizedBox(
          width: widget.minSize!.width,
          height: _height,
          child: widget.isChildMode
              ? Stack(
                  children: [
                    Positioned.fill(child: platformView),
                    Center(child: IgnorePointer(child: widget.child!)),
                  ],
                )
              : platformView,
        );
      }

      return buttonWidget;
    }

    // Fallback to CupertinoButton on other platforms
    return _buildFallbackButton();
  }

  Widget _buildFallbackButton() {
    final buttonColor = widget.color ?? CupertinoColors.systemBlue;
    final textStyle = TextStyle(
      color: widget.textColor ?? CupertinoColors.white,
    );

    // If child mode, use the child widget
    final buttonChild = widget.isChildMode
        ? widget.child!
        : Text(widget.label, style: textStyle);

    switch (widget.style) {
      case IOS26ButtonStyle.filled:
        return CupertinoButton.filled(
          onPressed: widget.enabled ? widget.onPressed : null,
          padding:
              widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
          child: buttonChild,
        );

      case IOS26ButtonStyle.plain:
        return CupertinoButton(
          onPressed: widget.enabled ? widget.onPressed : null,
          padding:
              widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
          child: widget.isChildMode
              ? widget.child!
              : Text(
                  widget.label,
                  style: TextStyle(color: widget.textColor ?? buttonColor),
                ),
        );

      default:
        return CupertinoButton(
          onPressed: widget.enabled ? widget.onPressed : null,
          color: buttonColor,
          padding:
              widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
          child: buttonChild,
        );
    }
  }
}
