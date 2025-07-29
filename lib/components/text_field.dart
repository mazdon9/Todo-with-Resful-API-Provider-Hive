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

  const AppTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.maxLines = 1,
    this.style,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: style ?? AppTextStyle.textFontR15W400,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.textFontR15W400,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColorsPath.lavenderLight, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColorsPath.lavenderLight, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColorsPath.lavenderLight,
            width: 1.2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        isDense: true,
      ),
    );
  }
}
