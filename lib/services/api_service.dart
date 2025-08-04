import 'dart:math';

import 'package:http/http.dart';
import 'package:todo_with_resfulapi/models/tasks.dart';
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://task-manager-api3.p.rapidapi.com/';
  static const String _apiKey =
      '67bf9311ccmsh5c0f38290745835p18ab45jsnaaed529f2a0d';
  static const String _apiHost = 'task-manager-api3.p.rapidapi.com';
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'x-rapidapi-host': _apiHost,
    'x-rapidapi-key': _apiKey,
  };

  // get all tasks
  Future<List<Task>> getTasks() async {
    try {
      final response = await get(Uri.parse(_baseUrl), headers: _headers);
      Map<String, dynamic>? jsonResponse;
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
      }
      if (jsonResponse != null &&
          jsonResponse['status'] == 'Success' &&
          jsonResponse['data'] != null) {
        final List<dynamic> taskList = jsonResponse['data'] as List;
        return taskList.map((taskJson) {
          return Task.fromJson(taskJson);
        }).toList();
      } else {
        throw Exception(
            'Failed to load tasks: ${jsonResponse?['message'] ?? response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to load tasks');
    }
  }
}
