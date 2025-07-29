import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/screen/home_screen_documentation.dart';

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
      home: mainScreenDocumentation(),
    );
  }
}
