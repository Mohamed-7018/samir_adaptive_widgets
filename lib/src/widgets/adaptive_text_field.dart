import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../platform/platform_info.dart';

class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.autocorrect = true,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.padding,
    this.decoration,
  });
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final bool autocorrect;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? padding;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    if (PlatformInfo.isIOS) {
      return _buildCupertinoTextField(context);
    }

    return _buildMaterialTextField(context);
  }

  Widget _buildCupertinoTextField(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      focusNode: focusNode,
      placeholder: placeholder,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      obscureText: obscureText,
      autocorrect: autocorrect,
      autofocus: autofocus,
      enabled: enabled,
      readOnly: readOnly,
      prefix:
          prefix ??
          (prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: GestureDetector(
                    onTap: () {
                      // Prevent focus when tapping on prefix icon
                    },
                    child: prefixIcon,
                  ),
                )
              : null),
      suffix:
          suffix ??
          (suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () {
                      // Prevent focus when tapping on suffix icon
                    },
                    child: suffixIcon,
                  ),
                )
              : null),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      inputFormatters: inputFormatters,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: enabled
            ? CupertinoColors.tertiarySystemBackground
            : CupertinoColors.quaternarySystemFill,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildMaterialTextField(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      obscureText: obscureText,
      autocorrect: autocorrect,
      autofocus: autofocus,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      inputFormatters: inputFormatters,
      decoration:
          decoration ??
          InputDecoration(
            hintText: placeholder,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            prefix: prefix,
            suffix: suffix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
    );
  }
}
