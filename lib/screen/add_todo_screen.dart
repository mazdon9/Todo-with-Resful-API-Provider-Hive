import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_button.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/components/text_field.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';

class AddTodoScreen extends StatelessWidget {
  const AddTodoScreen({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(hintText: 'Title'),
              const SizedBox(height: 24),
              AppTextField(hintText: 'Detail', maxLines: 2),
              const SizedBox(height: 40),
              Center(
                child: AppButton(
                  content: 'ADD',
                  onTap: () {},
                  width: size.width - 48,
                  borderRadius: 12,
                  textStyle: AppTextStyle.textFontSM20W600,
                  color: AppColorsPath.lavender,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
