import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? textColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: iconColor ?? AppColorsPath.grey),
          SizedBox(height: 16),
          AppText(
            title: title,
            style: AppTextStyle.textFont24W600.copyWith(
              color: textColor ?? AppColorsPath.grey,
            ),
          ),
          SizedBox(height: 8),
          AppText(
            title: subtitle,
            style: AppTextStyle.textFontR10W400.copyWith(
              color: textColor ?? AppColorsPath.grey,
            ),
          ),
        ],
      ),
    );
  }
}
