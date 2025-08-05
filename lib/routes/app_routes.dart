import 'package:todo_with_resfulapi/screens/home_screen.dart';

class AppRoutes {
  static const String homeScreenRouter = 'home-screen';
  static const String addTodoScreeRouter = 'add-todo-screen';
  static const String completedTaskScreenRouter = 'completed-task-screen';
  static const String editTodoScreenRouter = 'edit-todo-screen';

  static final routes = {
    homeScreenRouter: (context) => const HomeScreen(),
    // addTodoScreeRouter: (context) => const AddTodoScreen(),
    // editTodoScreenRouter: (context) => const EditTodoScreen(),
    // completedTaskScreenRouter: (context) => const CompletedTaskScreen(),
  };
}
