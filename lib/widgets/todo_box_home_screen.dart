import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/task.dart';

class TodoBox extends StatelessWidget {
  final Task task;
  final VoidCallback? onStatusChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TodoBox({
    super.key,
    required this.task,
    this.onStatusChanged,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColorsPath.white,
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
                    title: task.title,
                    style: AppTextStyle.textFontSM13W600.copyWith(
                      decoration:
                          task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    AppText(
                      title: task.description,
                      style: AppTextStyle.textFontR10W400.copyWith(
                        color: AppColorsPath.black,
                        decoration:
                            task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: AppColorsPath.lavender),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: AppColorsPath.lavender),
              onPressed: onDelete,
            ),
            IconButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: AppColorsPath.lavender,
              ),
              onPressed: onStatusChanged,
            ),
          ],
        ),
      ),
    );
  }
}
