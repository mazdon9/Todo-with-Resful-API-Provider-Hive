import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/components/app_button.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/components/text_field.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/todo_model.dart';
import 'package:todo_with_resfulapi/providers/todo_provider.dart';

class EditTodoScreen extends StatefulWidget {
  const EditTodoScreen({super.key});

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  late TodoModel todo;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args is TodoModel) {
        todo = args;
        titleController.text = todo.title;
        detailController.text = todo.detail;
        isInit = true;
      }
    }
    super.didChangeDependencies();
  }

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
        title: Text('Edit Task', style: AppTextStyle.textFont24W600),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppButton(
                    content: 'Update',
                    onTap: () {
                      if (titleController.text.isNotEmpty) {
                        // Update via provider
                        final updatedTodo = TodoModel(
                          id: todo.id,
                          title: titleController.text.trim(),
                          detail: detailController.text.trim(),
                          isCompleted: todo.isCompleted,
                        );

                        final todoProvider = Provider.of<TodoProvider>(
                          context,
                          listen: false,
                        );
                        todoProvider.updateTodo(updatedTodo);
                        Navigator.pop(context);
                      }
                    },
                    width:
                        (size.width - 90) /
                        2, // Half width minus padding and gap
                    borderRadius: 12,
                    textStyle: AppTextStyle.textFontSM20W600,
                    color: AppColorsPath.lavender,
                  ),
                  AppButton(
                    content: 'Cancel',
                    onTap: () {
                      Navigator.pop(context);
                    },
                    width:
                        (size.width - 90) /
                        2, // Half width minus padding and gap
                    borderRadius: 12,
                    textStyle: AppTextStyle.textFontSM20W600,
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
