import 'package:flutter/material.dart';

import '../components/app_text.dart';
import '../components/app_text_style.dart';
import '../constants/app_color_path.dart';
import '../constants/app_data.dart';
import '../models/todo_model.dart';
import '../routes/app_routes.dart';
import '../widgets/bottom_nav_bar_widget_home_screen.dart';
import '../widgets/todo_box_home_screen.dart';

class MainScreenDocumentation extends StatelessWidget {
  const MainScreenDocumentation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lavender,
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: AppColorsPath.lavenderLight),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) => TodoBox(
                  todo: TodoModel(
                    title: 'Sample Todo ${index + 1}',
                    detail: 'Sample Detail ${index + 1}',
                    isCompleted: false,
                  ),
                ),
              ),
            ),
          ),
          const BottomNavBarWidget(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 63, right: 22),
        child: PhysicalModel(
          color: AppColorsPath.lavender,
          elevation: 6,
          shape: BoxShape.circle,

          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: AppColorsPath.lavender,
              elevation: 0,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addTodoScreeRouter);
              },
              shape: const CircleBorder(),
              child: Icon(Icons.add, color: AppColorsPath.white, size: 36),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
