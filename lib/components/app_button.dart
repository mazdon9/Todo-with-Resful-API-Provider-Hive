import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';

class AppButton extends StatelessWidget {
  final String content;
  final VoidCallback onTap;
  final double? width;
  final TextStyle? textStyle;
  final Color? color;
  final double borderRadius;

  const AppButton({
    required this.content,
    required this.onTap,
    this.width,
    this.textStyle,
    this.color,
    this.borderRadius = 59,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (width ?? (65 / 414) * size.width),
        height: (65 / 414) * size.width,
        decoration: BoxDecoration(
          color: color ?? AppColorsPath.lavender,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: AppText(
            title: content,
            style: textStyle ?? AppTextStyle.textFontSM20W600,
          ),
        ),
      ),
    );
  }
}
