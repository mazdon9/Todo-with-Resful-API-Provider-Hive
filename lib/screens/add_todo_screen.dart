import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_button.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/components/text_field.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/todo_model.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final titleController = TextEditingController();
  final detailController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    detailController.dispose();
    super.dispose();
  }

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
              AppTextField(hintText: 'Title', controller: titleController),
              const SizedBox(height: 43),
              AppTextField(
                hintText: 'Detail',
                maxLines: 1,
                controller: detailController,
              ),
              const SizedBox(height: 54),
              Center(
                child: AppButton(
                  content: 'ADD',
                  onTap: () {
                    if (titleController.text.isNotEmpty) {
                      Navigator.pop(
                        context,
                        TodoModel(
                          title: titleController.text.trim(),
                          detail: detailController.text.trim(),
                        ),
                      );
                    }
                  },
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
