import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Campo de texto reutilizable con contador, validación y soporte de teclado accesible.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final String? counterText;
  final String? errorText;
  final int? maxLength;
  final int maxLines;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    this.hintText,
    this.counterText,
    this.errorText,
    this.maxLength,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
            if (counterText != null)
              Text(
                counterText!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            counterText: '',
          ),
        ),
      ],
    );
  }
}
