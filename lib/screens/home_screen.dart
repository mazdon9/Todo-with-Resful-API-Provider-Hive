import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/constants/app_data.dart';
import 'package:todo_with_resfulapi/widgets/bottom_nav_bar_widget_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lavenderLight,
      appBar: AppBar(
        backgroundColor: AppColorsPath.lavender,
        elevation: 0,
        title: AppText(
          title: AppData.appName,
          style: AppTextStyle.textFont24W600,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_month_outlined,
              color: AppColorsPath.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(top: 22, left: 7, right: 7),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColorsPath.white,
              ),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          title: "TODO TITLE",
                          style: AppTextStyle.textFontSM13W600.copyWith(
                            color: AppColorsPath.lavender,
                          ),
                        ),
                        AppText(
                          title: "TODO SUB TITLE",
                          style: AppTextStyle.textFontR10W400.copyWith(
                            color: AppColorsPath.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.check_circle)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
