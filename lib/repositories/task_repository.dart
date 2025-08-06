import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/services/api_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();

  /// Get all tasks from the API
  Future<List<Task>> getAllTasks() async {
    try {
      return await _apiService.getAllTasks();
    } catch (e) {
      debugPrint('Error fetching tasks in ReTaskRepositoryposi: $e');
      throw Exception('Failed to fetch tasks TaskRepository $e');
    }
  }
}
