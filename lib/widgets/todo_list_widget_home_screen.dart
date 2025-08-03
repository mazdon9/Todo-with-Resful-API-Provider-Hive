import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/tasks.dart';
import 'package:todo_with_resfulapi/widgets/todo_box_widget_home_screen.dart';

class TodoListWidget extends StatelessWidget {
  final List<Task> tasks;
  final EdgeInsetsGeometry? padding;
  final Function(Task task)? onTodoStatusChanged;
  final Function(Task task)? onTodoEdit;
  final Function(Task task)? onTodoDelete;

  const TodoListWidget({
    super.key,
    required this.tasks,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    this.onTodoStatusChanged,
    this.onTodoEdit,
    this.onTodoDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: AppText(
          title: 'No things here.',
          style: AppTextStyle.textFontSM20W600.copyWith(
            color: AppColorsPath.black,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: padding,
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final todo = tasks[index];
        return TodoBox(
          task: todo,
          onStatusChanged: () => onTodoStatusChanged?.call(todo),
          onEdit: () => onTodoEdit?.call(todo),
          onDelete: () => onTodoDelete?.call(todo),
        );
      },
    );
  }
}
