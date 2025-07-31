import 'package:todo_with_resfulapi/screen/home_screen.dart';
import 'package:todo_with_resfulapi/screen/add_todo_screen.dart';
import 'package:todo_with_resfulapi/screen/edit_todo_screen.dart';
import 'package:todo_with_resfulapi/screen/completed_task_screen.dart';

class AppRoutes {
  static const String homeScreenRouter = 'home-screen-documentation';
  static const String addTodoScreeRouter = 'add-todo-screen';
  static const String completedTaskScreenRouter = 'completed-task-screen';
  static const String editTodoScreenRouter = 'edit-todo-screen';

  static final routes = {
    homeScreenRouter: (context) => const MainScreenDocumentation(),
    addTodoScreeRouter: (context) => const AddTodoScreen(),
    editTodoScreenRouter: (context) => const EditTodoScreen(),
    completedTaskScreenRouter: (context) => const CompletedTaskScreen(),
  };
}
