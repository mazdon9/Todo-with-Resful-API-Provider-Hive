import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/task.dart';

class DialogWidgetCompletedScreen {
  /// Show undo confirmation dialog
  static Future<bool?> showUndoConfirmDialog(
    BuildContext context,
    Task task,
  ) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Undo Task Completion'),
            content: Text('Mark "${task.title}" as pending again?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Undo',
                  style: TextStyle(color: AppColorsPath.warningOrange),
                ),
              ),
            ],
          ),
    );
  }

  /// Show delete confirmation dialog
  static Future<bool?> showDeleteConfirmDialog(
    BuildContext context,
    Task task,
  ) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Task'),
            content: Text(
              'Are you sure you want to permanently delete "${task.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: TextStyle(color: AppColorsPath.errorRed),
                ),
              ),
            ],
          ),
    );
  }
}
