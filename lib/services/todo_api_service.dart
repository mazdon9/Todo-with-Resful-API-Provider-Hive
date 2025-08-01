import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_with_resfulapi/models/todo_model.dart';

class TodoApiService {
  final String baseUrl = 'https://task-manager-api3.p.rapidapi.com/';
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
    'x-rapidapi-key': '67bf9311ccmsh5c0f38290745835p18ab45jsnaaed529f2a0d',
  };

  // GET: Fetch all todos
  Future<List<TodoModel>> getTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl), headers: headers);
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TodoModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('API connection error: $e');
    }
  }

  // POST: Create a new todo
  Future<TodoModel> createTodo(TodoModel todo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode({
        'title': todo.title,
        'description': todo.detail,
        'status': todo.isCompleted ? 'completed' : 'pendiente',
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      return TodoModel.fromJson(data);
    } else {
      throw Exception('Failed to create todo: ${response.statusCode}');
    }
  }

  // PUT: Update an existing todo
  Future<TodoModel> updateTodo(String id, TodoModel todo) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id'),
      headers: headers,
      body: json.encode({
        'title': todo.title,
        'description': todo.detail,
        'status': todo.isCompleted ? 'completed' : 'pendiente',
      }),
    );

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      return TodoModel.fromJson(data);
    } else {
      throw Exception('Failed to update todo: ${response.statusCode}');
    }
  }

  // DELETE: Delete a todo
  Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$id'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete todo: ${response.statusCode}');
    }
  }
}
