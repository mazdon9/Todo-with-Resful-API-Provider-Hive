import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_with_resfulapi/models/task.dart';

class ApiService {
  static const String _baseUrl = 'https://task-manager-api3.p.rapidapi.com/';
  static const String _apiKey =
      '73f36bbf3emsh0485c276574c141p16ec83jsne2d270cfbfc0';
  static const String _apiHost = 'task-manager-api3.p.rapidapi.com';

  static const _header = {
    'Content-Type': 'application/json',
    'x-rapidapi-host': _apiHost,
    'x-rapidapi-key': _apiKey,
  };

  /// GET All Tasks
  Future<List<Task>> getAllTasks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _header);
      debugPrint('API response status code: ${response.statusCode}');
      debugPrint('API response body: ${response.body}');

      if (response.statusCode == 200) {
        /// Json api trả về dạng String '{id, title, description}'
        /// truyền qua json.decode để chuyển thành Map
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          final List<dynamic> listOfTasks = jsonResponse['data'] as List;

          return listOfTasks
              .map((taskJson) {
                return Task.fromJson(taskJson as Map<String, dynamic>);
              })
              .where((task) => task.id != null)
              .toList();
        } else {
          debugPrint('API wrong format');
          throw Exception('Failed to fetch tasks');
        }
      } else if (response.statusCode == 403) {
        debugPrint('API Key unauthorized or expired');
        throw Exception(
          'API Key unauthorized. Please check your RapidAPI subscription.',
        );
      } else if (response.statusCode == 429) {
        debugPrint('API rate limit exceeded');
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        debugPrint('API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to fetch tasks: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
      throw Exception('Failed to fetch tasks $e');
    }
  }

  /// POST - Create new task
  Future<void> createTask(String title, String description) async {
    try {
      final body = json.encode({
        'title': title,
        'description': description,
        "status": "pendiente",
      });

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _header,
        body: body,
      );

      debugPrint('Create task response status: ${response.statusCode}');
      debugPrint('Create task response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          debugPrint("Create task success");
        } else {
          throw Exception('Failed to create task - Invalid response format');
        }
      } else if (response.statusCode == 403) {
        throw Exception('API Key unauthorized or expired');
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        debugPrint(
          'Create task error: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error creating task: $e');
      throw Exception('Failed to create task: $e');
    }
  }

  /// PUT - Update existing task
  Future<void> updateTask(Task task) async {
    try {
      final body = json.encode(task.toJson());

      final response = await http.put(
        Uri.parse('$_baseUrl${task.id}'),
        headers: _header,
        body: body,
      );

      debugPrint('Update task response status: ${response.statusCode}');
      debugPrint('Update task response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Task updated successfully');
      } else if (response.statusCode == 403) {
        throw Exception('API Key unauthorized or expired');
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        debugPrint(
          'Update task error: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
      throw Exception('Failed to update task: $e');
    }
  }

  /// DELETE - Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$taskId'),
        headers: _header,
      );

      debugPrint('Delete task response status: ${response.statusCode}');
      debugPrint('Delete task response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Deletion successful
        debugPrint('Task deleted successfully');
      } else if (response.statusCode == 403) {
        throw Exception('API Key unauthorized or expired');
      } else if (response.statusCode == 404) {
        throw Exception('Task not found');
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        debugPrint(
          'Delete task error: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleting task: $e');
      throw Exception('Failed to delete task: $e');
    }
  }
}
