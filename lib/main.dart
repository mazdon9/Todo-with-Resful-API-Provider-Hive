import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/routes/app_routes.dart';

void main() {
  runApp(const todoRestfulApi());
}

class todoRestfulApi extends StatelessWidget {
  const todoRestfulApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo with RESTful API.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.homeScreenRouter,
      routes: AppRoutes.routes,
    );
  }
}
