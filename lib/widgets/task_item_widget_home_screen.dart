import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';
import 'package:todo_with_resfulapi/routes/app_routes.dart';
import 'package:todo_with_resfulapi/widgets/dialog_widget_home_screen.dart';

class HomeTaskItemWidget extends StatelessWidget {
  final Task task;

  const HomeTaskItemWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
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
          padding: EdgeInsets.all(12),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title: task.title,
                      style: AppTextStyle.textFontSM13W600.copyWith(
                        color: AppColorsPath.lavender,
                      ),
                    ),
                    if (task.description.isNotEmpty)
                      AppText(
                        title: task.description,
                        style: AppTextStyle.textFontR10W400.copyWith(
                          color: AppColorsPath.black,
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
                              color: AppColorsPath.warningOrange.withOpacity(
                                0.1,
                              ),
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
              _buildActionButton(
                context,
                icon: Icons.edit,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.editTodoScreenRouter,
                    arguments: task,
                  );
                },
              ),

              _buildActionButton(
                context,
                icon: Icons.delete,
                color: AppColorsPath.errorRed,
                onPressed: () => _showDeleteConfirmDialog(context),
              ),

              _buildActionButton(
                context,
                icon: Icons.check_circle_outlined,
                color: AppColorsPath.successGreen,
                onPressed: () => _showCompleteConfirmDialog(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      visualDensity: VisualDensity.compact,
    );
  }

  // Show delete confirmation dialog
  Future<void> _showDeleteConfirmDialog(BuildContext context) async {
    final confirmed = await DialogWidgetHomeScreen.showDeleteConfirmDialog(
      context,
      task,
    );

    if (confirmed == true && context.mounted) {
      context.read<TaskProvider>().deleteTask(task.id ?? '');
    }
  }

  // Show complete confirmation dialog
  Future<void> _showCompleteConfirmDialog(BuildContext context) async {
    final confirmed = await DialogWidgetHomeScreen.showCompleteConfirmDialog(
      context,
      task,
    );

    if (confirmed == true && context.mounted) {
      context.read<TaskProvider>().toggleTaskCompletion(task);
    }
  }
}
