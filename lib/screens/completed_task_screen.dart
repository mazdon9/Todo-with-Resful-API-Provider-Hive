import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';
import 'package:todo_with_resfulapi/providers/todo_provider.dart';
import 'package:todo_with_resfulapi/widgets/todo_list_home_screen.dart';

class CompletedTaskScreen extends StatelessWidget {
  const CompletedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lavender,
      appBar: AppBar(
        backgroundColor: AppColorsPath.lavender,
        elevation: 0,
        title: AppText(
          title: 'Completed Tasks',
          style: AppTextStyle.textFont24W600,
        ),
        iconTheme: const IconThemeData(color: AppColorsPath.white),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColorsPath.lavenderLight),
        child: Consumer<TaskProvider>(
          builder: (context, todoProvider, child) {
            if (todoProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (todoProvider.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      title: 'Error loading completed todos',
                      style: AppTextStyle.textFontSM20W600,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      /// TODO: Retry
                      onPressed: () {},
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return TodoListWidget(
                tasks: todoProvider.completedTasks,
                // onTodoStatusChanged: todoProvider.toggleTodoStatus,
                // onTodoDelete: todoProvider.deleteTodo,
              );
            }
          },
        ),
      ),
    );
  }
}
