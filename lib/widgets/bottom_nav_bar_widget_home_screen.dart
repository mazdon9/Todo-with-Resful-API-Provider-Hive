import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/routes/app_routes.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (68 / 896) * MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: AppColorsPath.white),
      padding: const EdgeInsets.symmetric(horizontal: 91, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.homeScreenRouter),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.list_alt, color: AppColorsPath.lavender, size: 30),
                AppText(title: 'All', style: AppTextStyle.textFontR10W400),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.completedTaskScreenRouter,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, color: AppColorsPath.lavender, size: 30),
                AppText(
                  title: 'Completed',
                  style: AppTextStyle.textFontR10W400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
