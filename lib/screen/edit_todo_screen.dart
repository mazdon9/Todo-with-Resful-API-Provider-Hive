import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_button.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/components/text_field.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';

class EditTodoScreen extends StatelessWidget {
  const EditTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColorsPath.lavender,
      appBar: AppBar(
        backgroundColor: AppColorsPath.lavender,
        elevation: 0,
        title: Text('Add Task', style: AppTextStyle.textFont24W600),
        iconTheme: const IconThemeData(color: AppColorsPath.white),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppColorsPath.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 43),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(hintText: 'Title'),
              const SizedBox(height: 43),
              AppTextField(hintText: 'Detail', maxLines: 1),
              const SizedBox(height: 54),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    content: 'Update',
                    onTap: () {},
                    width: size.width - 48,
                    borderRadius: 12,
                    textStyle: AppTextStyle.textFontR15W400.copyWith(
                      color: AppColorsPath.white,
                    ),
                    color: AppColorsPath.lavender,
                  ),
                  AppButton(
                    content: 'Cancel',
                    onTap: () {},
                    width: size.width - 48,
                    borderRadius: 12,
                    textStyle: AppTextStyle.textFontR15W400.copyWith(
                      color: AppColorsPath.white,
                    ),
                    color: AppColorsPath.lavender,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
