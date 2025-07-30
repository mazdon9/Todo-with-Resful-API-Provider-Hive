import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/components/app_button.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/provider/demo_provider.dart';
import 'package:http/http.dart' as http;

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final url = Uri.parse('https://dummyjson.com/auth/login');
  final Map<String, String> headers = {'Content-Type': 'application/json'};
  final body = {
    "username": "emilys",
    "password": "emilyspass",
    "expiresInMins": 30,
  };

  String userName = '';

  @override
  Widget build(BuildContext context) {
    //     fetch('https://dummyjson.com/auth/login', {
    //   method: 'POST',
    //   headers: { 'Content-Type': 'application/json' },
    //   body: JSON.stringify({

    //     username: 'emilys',
    //     password: 'emilyspass',
    //     expiresInMins: 30, // optional, defaults to 60
    //   }),
    //   credentials: 'include' // Include cookies (e.g., accessToken) in the request
    // })
    // .then(res => res.json())
    // .then(console.log);

    // final count = context.select(
    //   (DemoProvider demoProvider) => demoProvider.count,
    // );
    // final demoProvider = context.watch<DemoProvider>();
    // int sum = 0;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Consumer<DemoProvider>(
          //   builder: (context, demoProvider, child) {
          //     return AppText(
          //       title: demoProvider.count.toString(),
          //       style: AppTextStyle.textFont24W600.copyWith(color: Colors.red),
          //     );
          //   },
          // ),
          // Selector<DemoProvider, int>(
          //   builder: (context, count, child) {
          //     return AppText(
          //       title: count.toString(),
          //       style: AppTextStyle.textFont24W600.copyWith(color: Colors.red),
          //     );
          //   },
          //   selector: (context, demoProvider) => demoProvider.count,
          // ),
          AppText(
            title: "UserName $userName ",
            style: AppTextStyle.textFont24W600.copyWith(color: Colors.red),
          ),
          // CircularProgressIndicator(),
          AppButton(
            width: 300,
            content: 'Increase',
            onTap: () async {
              // context.read<DemoProvider>().increaseCount();
              final response = await http.post(
                url,
                headers: headers,
                body: jsonEncode(body),
              );
              print('Response status: ${response.statusCode}');
              print('Response body: ${response.body}');

              setState(() {
                final data = jsonDecode(response.body);
                userName = data['title'];
              });
            },
          ),
          SizedBox(height: 40),
          AppButton(
            width: 300,
            content: 'Decrease',
            onTap: () {
              // context.read<DemoProvider>().increaseAge();
              print("Decrease");
            },
          ),
        ],
      ),
    );
  }
}
