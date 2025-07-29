import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/widget/todo_box_widget_main_screen_documentation.dart';

import '../components/app_text.dart';
import '../components/app_text_style.dart';
import '../constants/app_color_path.dart';
import '../constants/app_data.dart';
// import '../components/app_button.dart';

class mainScreenDocumentation extends StatelessWidget {
  const mainScreenDocumentation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPathPath.lavender,
      appBar: AppBar(
        backgroundColor: AppColorsPathPath.lavender,
        elevation: 0,
        title: AppText(
          title: AppData.appName,
          style: AppTextStyle.textFont24W600,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_month_outlined,
              color: AppColorsPathPath.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: AppColorsPathPath.lavenderLight),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) => TodoBox(),
              ),
            ),
          ),
          const _BottomNavBar(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60, right: 22),
        child: PhysicalModel(
          color: AppColorsPathPath.lavender,
          elevation: 6,
          shape: BoxShape.circle,
          shadowColor: Colors.black26,
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: AppColorsPathPath.lavender,
              elevation: 0,
              onPressed: () {},
              shape: const CircleBorder(),
              child: Icon(Icons.add, color: AppColorsPathPath.white, size: 36),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (68 / 896) * MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: AppColorsPathPath.white),
      padding: const EdgeInsets.symmetric(horizontal: 91, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.list_alt, color: AppColorsPathPath.lavender),
              AppText(title: 'All', style: AppTextStyle.textFontR10W400),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, color: AppColorsPathPath.lavender),
              AppText(title: 'Completed', style: AppTextStyle.textFontR10W400),
            ],
          ),
        ],
      ),
    );
  }
}
