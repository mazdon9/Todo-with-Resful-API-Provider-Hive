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
  Future<List<Task>> getAllTasks() async {
    try {
      debugPrint('Making API request to: $_baseUrl');
      debugPrint('Headers: $_headers');

      final response =
          await htt.get(Uri.parse(_baseUrl), headers: _headers).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('API request timeout after 10 seconds');
          throw Exception('Request timeout');
        },
      );

      debugPrint('Response received!');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          // First, try to parse as array directly
          final dynamic decoded = json.decode(response.body);
          debugPrint('Decoded response: $decoded');
          debugPrint('Response type: ${decoded.runtimeType}');

          if (decoded is List) {
            debugPrint('Response is direct array with ${decoded.length} items');
            List<Task> tasks = decoded.map((taskJson) {
              debugPrint('Converting task: $taskJson');
              return Task.fromJson(taskJson as Map<String, dynamic>);
            }).toList();
            return tasks;
          } else if (decoded is Map<String, dynamic>) {
            debugPrint('Response is object: $decoded');

            // Check if it's a success response with data array
            if (decoded['status'] == 'success' && decoded['data'] != null) {
              final List<dynamic> tasksJson = decoded['data'];
              debugPrint('Tasks data from success response: $tasksJson');
              List<Task> tasks = tasksJson.map((taskJson) {
                return Task.fromJson(taskJson as Map<String, dynamic>);
              }).toList();
              return tasks;
            }
            // Check if tasks are at root level
            else if (decoded['tasks'] != null) {
              final List<dynamic> tasksJson = decoded['tasks'];
              debugPrint('Tasks from root level: $tasksJson');
              List<Task> tasks = tasksJson.map((taskJson) {
                return Task.fromJson(taskJson as Map<String, dynamic>);
              }).toList();
              return tasks;
            } else {
              debugPrint(
                'API response error: ${decoded['message'] ?? 'Unknown format'}',
              );
              debugPrint('Full response: $decoded');
              return _getMockData(); // Return mock data when API error
            }
          } else {
            debugPrint('Unknown response format: ${decoded.runtimeType}');
            return _getMockData();
          }
        } catch (parseError) {
          debugPrint('JSON parsing error: $parseError');
          debugPrint('Raw response body: ${response.body}');
          return _getMockData(); // Return mock data when parse error
        }
      } else {
        debugPrint(
          'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}',
        );
        return _getMockData(); // Return mock data when HTTP error
      }
    } catch (e) {
      debugPrint('Network error: $e');
      return _getMockData(); // Return mock data when network error
    }
  }

  // Mock data for testing
  Future<List<Task>> _getMockData() async {
    debugPrint('Returning mock data...');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    return [
      Task(
        id: '1',
        title: 'Complete Flutter Project',
        description: 'Finish the todo app with REST API integration',
        status: 'pending',
      ),
      Task(
        id: '2',
        title: 'Review Code',
        description: 'Review and refactor the existing code',
        status: 'completed',
      ),
      Task(
        id: '3',
        title: 'Write Documentation',
        description: 'Create comprehensive documentation for the project',
        status: 'pending',
      ),
    ];
  }
}
