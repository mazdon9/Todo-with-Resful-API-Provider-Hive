import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/todo_list_view.dart';
import 'package:todo_with_resfulapi/models/todo_model.dart';
import 'package:todo_with_resfulapi/routes/app_routes.dart';

import '../components/app_text.dart';
import '../components/app_text_style.dart';
import '../constants/app_color_path.dart';
import '../constants/app_data.dart';

class MainScreenDocumentation extends StatefulWidget {
  const MainScreenDocumentation({super.key});

  @override
  State<MainScreenDocumentation> createState() =>
      _MainScreenDocumentationState();
}

class _MainScreenDocumentationState extends State<MainScreenDocumentation> {
  final List<TodoModel> _todos = [];

  void _onTodoStatusChanged(TodoModel todo) {
    setState(() {
      todo.isCompleted = !todo.isCompleted;
    });
  }

  void _addNewTodo(TodoModel? todo) {
    if (todo != null) {
      setState(() {
        _todos.add(todo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsPath.lavender,
      appBar: AppBar(
        backgroundColor: AppColorsPath.lavender,
        elevation: 0,
        title: AppText(
          title: AppData.appName,
          style: AppTextStyle.textFont24W600,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_month_outlined,
              color: AppColorsPath.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColorsPath.lavenderLight,
              ),
              child: TodoListView(
                todos: _todos,
                onTodoStatusChanged: _onTodoStatusChanged,
              ),
            ),
          ),
          const _BottomNavBar(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 63, right: 22),
        child: PhysicalModel(
          color: AppColorsPath.lavender,
          elevation: 6,
          shape: BoxShape.circle,

          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: AppColorsPath.lavender,
              elevation: 0,
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.addTodoScreeRouter,
                );
                _addNewTodo(result as TodoModel?);
              },
              shape: const CircleBorder(),
              child: Icon(Icons.add, color: AppColorsPath.white, size: 36),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (68 / 896) * MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: AppColorsPath.white),
      padding: const EdgeInsets.symmetric(horizontal: 91, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.list_alt, color: AppColorsPath.lavender),
              AppText(title: 'All', style: AppTextStyle.textFontR10W400),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, color: AppColorsPath.lavender),
              AppText(title: 'Completed', style: AppTextStyle.textFontR10W400),
            ],
          ),
        ],
      ),
    );
  }
}
