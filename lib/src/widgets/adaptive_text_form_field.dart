import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../platform/platform_info.dart';

class AdaptiveTextFormField extends StatelessWidget {
  const AdaptiveTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.initialValue,
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
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.padding,
    this.decoration,
    this.autovalidateMode,
  });
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final String? initialValue;
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
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? padding;
  final InputDecoration? decoration;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    if (PlatformInfo.isIOS) {
      return _buildCupertinoTextFormField(context);
    }

    return _buildMaterialTextFormField(context);
  }

  Widget _buildCupertinoTextFormField(BuildContext context) {
    return FormField<String>(
      initialValue: controller == null ? (initialValue ?? '') : null,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
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
              onChanged: (value) {
                field.didChange(value);
                onChanged?.call(value);
              },
              onSubmitted: onSubmitted,
              onTap: onTap,
              inputFormatters: inputFormatters,
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: enabled
                    ? CupertinoColors.tertiarySystemBackground
                    : CupertinoColors.quaternarySystemFill,
                border: field.hasError
                    ? Border.all(color: CupertinoColors.systemRed, width: 1)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (field.hasError && field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                    color: CupertinoColors.systemRed,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMaterialTextFormField(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
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
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      onSaved: onSaved,
      validator: validator,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      decoration:
          decoration ??
          InputDecoration(
            hintText: placeholder,
            prefixIcon: prefixIcon,
            // Use suffixIcon instead of suffix to prevent extra vertical space
            // Priority: suffixIcon parameter, then suffix parameter (mapped to suffixIcon)
            suffixIcon: suffixIcon ?? suffix,
            prefix: prefix,
            // Don't use suffix in InputDecoration - causes spacing issues
            isDense: true, // Critical for reducing extra space
            suffixIconConstraints: (suffixIcon ?? suffix) != null
                ? const BoxConstraints(minWidth: 48, minHeight: 48)
                : null,
            prefixIconConstraints: prefixIcon != null
                ? const BoxConstraints(minWidth: 48, minHeight: 48)
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
    );
  }
}
