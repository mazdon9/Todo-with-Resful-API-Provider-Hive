import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/provider/demo_provider.dart';
// import 'package:todo_with_resfulapi/routes/app_routes.dart';
import 'package:todo_with_resfulapi/screen/demo_screen.dart';

void main() {
  runApp(const TodoRestfulApi());
}

class TodoRestfulApi extends StatelessWidget {
  const TodoRestfulApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo with RESTful API.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      // initialRoute: AppRoutes.homeScreenRouter,
      // routes: AppRoutes.routes,
      home: ChangeNotifierProvider(
        create: (context) => DemoProvider(),
        child: const DemoScreen(),
      ),
    );
  }
}
