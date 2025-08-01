import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/models/todo_model.dart';
import 'package:todo_with_resfulapi/routes/app_routes.dart';
import 'package:todo_with_resfulapi/widgets/bottom_nav_bar_widget_home_screen.dart';
import 'package:todo_with_resfulapi/widgets/todo_list_home_screen.dart';

import '../components/app_text.dart';
import '../components/app_text_style.dart';
import '../constants/app_color_path.dart';
import '../constants/app_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              child: TodoListWidget(
                todos: _todos,
                onTodoStatusChanged: _onTodoStatusChanged,
              ),
            ),
          ),
          const BottomNavBarWidget(),
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
