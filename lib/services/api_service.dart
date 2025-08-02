import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_with_resfulapi/models/task.dart';

class ApiService {
  static const String _baseUrl = 'https://task-manager-api3.p.rapidapi.com/';
  static const String _apiKey =
      '73f36bbf3emsh0485c276574c141p16ec83jsne2d270cfbfc0';
  static const String _apiHost = 'task-manager-api3.p.rapidapi.com';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'x-rapidapi-host': _apiHost,
    'x-rapidapi-key': _apiKey,
  };

  // Get All Tasks
  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          final List<dynamic> taskList = jsonResponse['data'] as List;

          return taskList.map((taskJson) {
            return Task.fromJson(taskJson);
          }).toList();
        } else {
          throw Exception(
            "Failed to fetch tasks message: ${jsonResponse['message']}}",
          );
        }
      } else {
        throw Exception("Failed to fetch tasks: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
      throw Exception("Failed to fetch tasks: $e");
    }
  }
}
