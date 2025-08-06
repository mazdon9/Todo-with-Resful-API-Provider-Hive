// lib/screens/completed_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (_, taskProvider, __) {
        return Scaffold(
          backgroundColor: AppColorsPath.lavenderLight,
          appBar: AppBar(
            backgroundColor: AppColorsPath.lavender,
            title: AppText(
              title: 'Completed Tasks',
              style: AppTextStyle.textFont24W600.copyWith(
                color: AppColorsPath.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                taskProvider.completedTasks.isEmpty
                    ? Center(
                      child: AppText(
                        title: 'No completed tasks yet',
                        style: AppTextStyle.textFont24W600.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                    : ListView.separated(
                      itemCount: taskProvider.completedTasks.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final task = taskProvider.completedTasks[index];
                        return _buildCompletedTaskItem(context, task);
                      },
                    ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedTaskItem(BuildContext context, Task task) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColorsPath.white,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title: task.title,
                  style: AppTextStyle.textFontSM13W600.copyWith(
                    color: AppColorsPath.lavender,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                AppText(
                  title: task.description,
                  style: AppTextStyle.textFontR10W400.copyWith(
                    color: AppColorsPath.black,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 30),
        ],
      ),
    );
  }
}
