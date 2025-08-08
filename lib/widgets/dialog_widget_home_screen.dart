import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/task.dart';

class DialogWidgetHomeScreen {
  /// Show delete confirmation dialog
  static Future<bool?> showDeleteConfirmDialog(
    BuildContext context,
    Task task, {
    String? title,
    String? message,
    Color? confirmButtonColor,
    String? confirmTextButton,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title ?? 'Delete Task'),
            content: Text(
              message ?? 'Are you sure you want to delete "${task.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  confirmTextButton ?? 'Delete',
                  style: TextStyle(
                    color: confirmButtonColor ?? AppColorsPath.errorRed,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Show complete confirmation dialog
  static Future<bool?> showCompleteConfirmDialog(
    BuildContext context,
    Task task,
  ) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Complete Task'),
            content: Text('Mark "${task.title}" as completed?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Complete',
                  style: TextStyle(color: AppColorsPath.successGreen),
                ),
              ),
            ],
          ),
    );
  }
}
