import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/service/api_service.dart';
import 'package:flutter/foundation.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();

  // get all tasks form api service
  Future<List<Task>> getAllTasks() async {
    try {
      return await _apiService.getAllTask();
    } catch (e) {
      debugPrint('Error in TaskRepository: $e');
      throw Exception('Failed to load tasks');
    }
  }
}
