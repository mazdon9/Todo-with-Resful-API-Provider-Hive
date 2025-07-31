import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/todo_model.dart';
import 'package:todo_with_resfulapi/widgets/todo_box.dart';

class TodoListWidget extends StatelessWidget {
  final List<TodoModel> todos;
  final EdgeInsetsGeometry? padding;
  final Function(TodoModel todo)? onTodoStatusChanged;
  final Function(TodoModel todo)? onTodoEdit;
  final Function(TodoModel todo)? onTodoDelete;

  const TodoListWidget({
    super.key,
    required this.todos,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    this.onTodoStatusChanged,
    this.onTodoEdit,
    this.onTodoDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(
        child: AppText(
          title: 'No tasks to perform.',
          style: AppTextStyle.textFontSM20W600.copyWith(
            color: AppColorsPath.black,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: padding,
      itemCount: todos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoBox(
          todo: todo,
          onStatusChanged: () => onTodoStatusChanged?.call(todo),
          onEdit: () => onTodoEdit?.call(todo),
          onDelete: () => onTodoDelete?.call(todo),
        );
      },
    );
  }
}
