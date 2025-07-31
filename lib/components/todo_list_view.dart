import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/todo_model.dart';
import 'package:todo_with_resfulapi/widget/todo_box_widget_main_screen_documentation.dart';

class TodoListView extends StatelessWidget {
  final List<TodoModel> todos;
  final EdgeInsetsGeometry? padding;
  final Function(TodoModel todo)? onTodoStatusChanged;

  const TodoListView({
    super.key,
    required this.todos,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    this.onTodoStatusChanged,
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
          onStatusChanged: () {
            onTodoStatusChanged?.call(todo);
          },
        );
      },
    );
  }
}
