import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/models/todo_model.dart';
import 'package:todo_with_resfulapi/providers/todo_provider.dart';
import 'package:todo_with_resfulapi/routes/app_routes.dart';
import 'package:todo_with_resfulapi/widgets/bottom_nav_bar_widget_home_screen.dart';
import 'package:todo_with_resfulapi/widgets/todo_list_home_screen.dart';

import '../components/app_text.dart';
import '../components/app_text_style.dart';
import '../constants/app_color_path.dart';
import '../constants/app_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              child: Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  if (todoProvider.status == LoadingStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (todoProvider.status == LoadingStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            title: 'Error loading todos',
                            style: AppTextStyle.textFontSM20W600,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => todoProvider.fetchTodos(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return TodoListWidget(
                      todos: todoProvider.todos,
                      onTodoStatusChanged: todoProvider.toggleTodoStatus,
                      onTodoEdit: (todo) => Navigator.pushNamed(
                        context,
                        AppRoutes.editTodoScreenRouter,
                        arguments: todo,
                      ),
                      onTodoDelete: todoProvider.deleteTodo,
                    );
                  }
                },
              ),
            ),
          ),
          const BottomNavBarWidget(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 63, right: 22),
        child: PhysicalModel(
          color: AppColorsPath.lavender,
          elevation: 6,
          shape: BoxShape.circle,

          child: SizedBox(
            width: 70,
            height: 70,
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return FloatingActionButton(
                  backgroundColor: AppColorsPath.lavender,
                  elevation: 0,
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.addTodoScreeRouter,
                    );
                    if (result != null) {
                      todoProvider.addTodo(result as TodoModel);
                    }
                  },
                  shape: const CircleBorder(),
                  child: Icon(Icons.add, color: AppColorsPath.white, size: 36),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
