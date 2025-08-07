import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final int maxLines;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String labelText;

  const AppTextField({
    super.key,
    this.hintText = '',
    this.controller,
    this.maxLines = 1,
    this.style,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.labelText = 'Title',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: style ?? AppTextStyle.textFontR16W400,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AppColorsPath.white,
      ),
    );
  }
}
