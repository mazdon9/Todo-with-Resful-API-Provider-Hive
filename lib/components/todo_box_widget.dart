import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/todo_model.dart';

class TodoBox extends StatefulWidget {
  final TodoModel todo;

  const TodoBox({super.key, required this.todo});

  @override
  State<TodoBox> createState() => _TodoBoxState();
}

class _TodoBoxState extends State<TodoBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorsPath.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.todo.title,
                  style: AppTextStyle.textFontM17W500.copyWith(
                    color: AppColorsPath.black,
                    decoration: widget.todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (widget.todo.detail.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.todo.detail,
                    style: AppTextStyle.textFontR15W400.copyWith(
                      color: AppColorsPath.grey,
                      decoration: widget.todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Checkbox(
            value: widget.todo.isCompleted,
            onChanged: (value) {
              setState(() {
                widget.todo.isCompleted = value ?? false;
              });
            },
            activeColor: AppColorsPath.lavender,
          ),
        ],
      ),
    );
  }
}
