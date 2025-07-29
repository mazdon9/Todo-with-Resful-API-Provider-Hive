import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_button.dart';

class AddTodoScreen extends StatelessWidget {
  const AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Todo')),
      body: Center(
        child: AppButton(content: 'ADD', onTap: () {}),
      ),
    );
  }
}
