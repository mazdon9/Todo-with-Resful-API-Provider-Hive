import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as htt;
import 'package:todo_with_resfulapi/models/task.dart';

class ApiService {
  final String _baseUrl = 'https://task-manager-api3.p.rapidapi.com/';
  final String _apiKey = '67bf9311ccmsh5c0f38290745835p18ab45jsnaaed529f2a0d';
  final String _apiHost = 'task-manager-api3.p.rapidapi.com';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-RapidAPI-Key': _apiKey,
    'X-RapidAPI-Host': _apiHost,
  };

  // Fetch all tasks
  Future<List<Task>> getAllTask() async {
    try {
      final response = await htt.get(Uri.parse(_baseUrl), headers: _headers);
      debugPrint('Response: ${response.body}');
      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          final List<dynamic> tasksJson = jsonResponse['data'];
          return tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList();
        } else {
          debugPrint('Error: ${jsonResponse['message']}');
          throw Exception('Failed to load tasks');
        }
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
      throw Exception('Error fetching tasks: $e');
    }
  }
}
