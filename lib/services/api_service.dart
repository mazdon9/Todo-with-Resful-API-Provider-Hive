import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_with_resfulapi/models/task.dart';

class ApiService {
  static const String _baseUrl = 'https://task-manager-api3.p.rapidapi.com/';
  static const String _apiKey =
      '67bf9311ccmsh5c0f38290745835p18ab45jsnaaed529f2a0d';
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
}
