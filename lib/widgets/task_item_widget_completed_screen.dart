import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';
import 'package:todo_with_resfulapi/widgets/dialog_widget_completed_screen.dart';

class CompletedTaskItemWidget extends StatelessWidget {
  final Task task;
  final TaskProvider taskProvider;

  const CompletedTaskItemWidget({
    super.key,
    required this.task,
    required this.taskProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColorsPath.white,
        boxShadow: [
          BoxShadow(
            color: AppColorsPath.shadowGrey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Task Status Indicator (for local tasks or tasks with pending sync)
          FutureBuilder<bool>(
            future:
                task.id?.startsWith('local_') == true
                    ? Future.value(true)
                    : taskProvider.taskHasPendingSync(task.id ?? ''),
            builder: (context, snapshot) {
              final hasPendingSync = snapshot.data ?? false;

              if (hasPendingSync) {
                return Container(
                  width: 4,
                  height: 40,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColorsPath.warningOrange,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),

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
                if (task.description.isNotEmpty)
                  AppText(
                    title: task.description,
                    style: AppTextStyle.textFontR10W400.copyWith(
                      color: AppColorsPath.black,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),

                // Pending sync indicator
                FutureBuilder<bool>(
                  future:
                      task.id?.startsWith('local_') == true
                          ? Future.value(true)
                          : taskProvider.taskHasPendingSync(task.id ?? ''),
                  builder: (context, snapshot) {
                    final hasPendingSync = snapshot.data ?? false;

                    if (hasPendingSync) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        margin: EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: AppColorsPath.warningOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColorsPath.warningOrange,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          'Pending sync',
                          style: TextStyle(
                            color: AppColorsPath.warningOrange,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          // Action Buttons
          IconButton(
            onPressed: () => _showUndoConfirmDialog(context),
            icon: Icon(Icons.undo, color: AppColorsPath.warningOrange),
            visualDensity: VisualDensity.compact,
          ),

          IconButton(
            onPressed: () => _showDeleteConfirmDialog(context),
            icon: Icon(Icons.delete, color: AppColorsPath.errorRed),
            visualDensity: VisualDensity.compact,
          ),

          Icon(Icons.check_circle, color: AppColorsPath.successGreen, size: 30),
        ],
      ),
    );
  }

  // Show undo confirmation dialog
  Future<void> _showUndoConfirmDialog(BuildContext context) async {
    final confirmed = await DialogWidgetCompletedScreen.showUndoConfirmDialog(
      context,
      task,
    );

    if (confirmed == true) {
      taskProvider.toggleTaskCompletion(task);
    }
  }

  // Show delete confirmation dialog
  Future<void> _showDeleteConfirmDialog(BuildContext context) async {
    final confirmed = await DialogWidgetCompletedScreen.showDeleteConfirmDialog(
      context,
      task,
    );

    if (confirmed == true) {
      taskProvider.deleteTask(task.id ?? '');
    }
  }
}
