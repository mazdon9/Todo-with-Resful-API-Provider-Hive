
import 'package:todo_with_resfulapi/screen/home_screen_documentation.dart';
import 'package:todo_with_resfulapi/screen/add_todo_screen.dart';
import 'package:todo_with_resfulapi/screen/edit_todo_screen.dart';
import 'package:todo_with_resfulapi/screen/completed_task_screen.dart';

class AppRoutes {
  static const String homeScreen = 'home-screen-documentation';
  static const String addTodoScreen = 'add-todo-screen';
  static const String editTodoScreen = 'edit-todo-screen';
  static const String completedTaskScreen = 'completed-task-screen';

  static const String initialRoute = homeScreen;

  static final routes = {
    homeScreen: (context) => const mainScreenDocumentation(),
    addTodoScreen: (context) => const AddTodoScreen(),
    editTodoScreen: (context) => const EditTodoScreen(),
    completedTaskScreen: (context) => const CompletedTaskScreen(),
  };
}
