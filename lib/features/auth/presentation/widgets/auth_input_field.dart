import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AuthInputField extends StatelessWidget {
  const AuthInputField({
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.isError = false,
    super.key,
  });

  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        obscureText: obscureText,
        obscuringCharacter: '*',
        cursorColor: isError ? const Color(0xFFDC2626) : AppColors.primary,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: TextStyle(
            color: isError ? const Color(0xFFB91C1C) : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          labelStyle: TextStyle(
            color: isError ? const Color(0xFFB91C1C) : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(
              color: isError
                  ? const Color(0xFFDC2626)
                  : const Color(0xFFEEEEEE),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(
              color: isError ? const Color(0xFFDC2626) : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
