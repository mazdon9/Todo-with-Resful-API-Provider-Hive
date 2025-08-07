import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/services/api_service.dart';
import 'package:todo_with_resfulapi/services/storage_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final Connectivity _connectivity = Connectivity();

  /// Init StorageService
  Future<void> init() async {
    await _storageService.init();
  }

  /// Get all tasks from the API or local hive
  Future<List<Task>> getAllTasks() async {
    try {
      if (await _isOnline()) {
        /// Get tasks from api and later save to local
        final tasks = await _apiService.getAllTasks();
        await _storageService.saveAllTasks(tasks);
        return tasks;
      } else {
        /// Get tasks from local hive
        return await _storageService.getAllTasks();
      }
    } catch (e) {
      debugPrint('Error fetching tasks in TaskRepository: $e');
      return await _storageService.getAllTasks();
    }
  }

  /// Create new task
  Future<void> createTask(String title, String description) async {
    try {
      await _apiService.createTask(title, description);
    } catch (e) {
      throw Exception('Repository: Failed to create task - $e');
    }
  }

  /// Update existing task
  Future<void> updateTask(Task task) async {
    try {
      await _apiService.updateTask(task);
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
  Future<void> toggleTaskCompletion(Task task) async {
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
      await _apiService.updateTask(updatedTask);
    } catch (e) {
      throw Exception('Repository: Failed to toggle task completion - $e');
    }
  }

  Future<bool> _isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Repository: Failed to check internet connection - $e');
      return false;
    }
  }
}
