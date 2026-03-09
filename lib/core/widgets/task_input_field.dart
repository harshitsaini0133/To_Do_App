import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/core/constants/app_constants.dart';
import 'package:to_do_app/core/theme/app_colors.dart';
import 'package:to_do_app/core/theme/app_typography.dart';
import 'package:to_do_app/core/widgets/app_spacings.dart';

class TaskInputField extends StatefulWidget {
  const TaskInputField({
    super.key,
    required this.hintText,
    this.label,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.inputFormatters,
  });

  final String hintText;
  final String? label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends State<TaskInputField> {
  late final FocusNode _focusNode;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final glowColor = isFocused
        ? AppColors.primary.withValues(alpha: 0.18)
        : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.textTheme.labelLarge,
          ),
          AppSpacing.h(context, 10),
        ],
        AnimatedContainer(
          duration: AppConstants.fastAnimation,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.circular(context, 26),
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: 22,
                spreadRadius: 2,
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            obscureText: _obscureText,
            focusNode: _focusNode,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            style: AppTypography.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                      icon: Icon(
                        _obscureText
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomField extends TaskInputField {
  const CustomField({
    super.key,
    required super.hintText,
    super.label,
    super.controller,
    super.validator,
    super.prefixIcon,
    super.suffixIcon,
    super.keyboardType,
    super.textInputAction,
    super.maxLines,
    super.readOnly,
    super.obscureText,
    super.autofocus,
    super.onTap,
    super.onChanged,
    super.inputFormatters,
  });
}
