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
      debugPrint('Error fetching tasks in TaskRepository: $e');
      throw Exception('Failed to fetch tasks TaskRepository $e');
    }
  }

  /// Create new task
  Future<Task> createTask(String title, String description) async {
    try {
      return await _apiService.createTask(title, description);
    } catch (e) {
      throw Exception('Repository: Failed to create task - $e');
    }
  }

  /// Update existing task
  Future<Task> updateTask(Task task) async {
    try {
      return await _apiService.updateTask(task);
    } catch (e) {
      throw Exception('Repository: Failed to update task - $e');
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _apiService.deleteTask(taskId);
    } catch (e) {
      throw Exception('Repository: Failed to delete task - $e');
    }
  }

  /// Toggle task completion status
  Future<Task> toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        status:
            task.isPending
                ? 'completada'
                : 'pendiente', // Toggle từ pendiente sang completada và ngược lại
      );
      return await _apiService.updateTask(updatedTask);
    } catch (e) {
      throw Exception('Repository: Failed to toggle task completion - $e');
    }
  }
}
