import 'package:flutter/material.dart';

void main() {
  runApp(const todoRestfulApi());
}

class todoRestfulApi extends StatelessWidget {
  const todoRestfulApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo with RESTful API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: todoRestfulApi(),
    );
  }
}
