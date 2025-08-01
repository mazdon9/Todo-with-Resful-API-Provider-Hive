import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';
import 'package:todo_with_resfulapi/routes/app_routes.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapter
  Hive.registerAdapter(TaskAdapter());

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const TodoRestfulApi(),
    ),
  );
}

class TodoRestfulApi extends StatelessWidget {
  const TodoRestfulApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo with RESTful API.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.homeScreenRouter,
      routes: AppRoutes.routes,
    );
  }
}
