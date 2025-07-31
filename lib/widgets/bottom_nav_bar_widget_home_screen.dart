import 'package:flutter/material.dart';

import '../components/app_text.dart';
import '../components/app_text_style.dart';
import '../constants/app_color_path.dart';

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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.list_alt, color: AppColorsPath.lavender, size: 30),
              AppText(title: 'All', style: AppTextStyle.textFontR10W400),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, color: AppColorsPath.lavender, size: 30),
              AppText(title: 'Completed', style: AppTextStyle.textFontR10W400),
            ],
          ),
        ],
      ),
    );
  }
}
