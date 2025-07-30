import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/constants/app_data.dart';

class TodoBox extends StatelessWidget {
  const TodoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title: AppData.todoTitle,
                    style: AppTextStyle.textFontSM13W600,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    title: AppData.todoSubTitle,
                    style: AppTextStyle.textFontR10W400,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: AppColorsPath.lavender),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: AppColorsPath.lavender),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: AppColorsPath.lavender,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
