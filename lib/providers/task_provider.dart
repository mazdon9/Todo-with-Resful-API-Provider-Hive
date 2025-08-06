import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  List<Task> get pendingTasks =>
      _tasks.where((task) => task.isPending).toList();

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool get hasError => _error != null;

  /// Get All Tasks From Repository
  Future<void> loadTasks() async {
    try {
      _setLoading(true);
      _clearError();
      _tasks = await _taskRepository.getAllTasks();

      /// Log
      debugPrint('Tasks Loaded Successfully');
      debugPrint('Tasks Loaded with length: ${_tasks.length}');
      debugPrint(
        'Tasks Loaded pendingTasks with length: ${pendingTasks.length}',
      );
      debugPrint(
        'Tasks Loaded completedTasks with length: ${completedTasks.length}',
      );
    } catch (e) {
      _setError('Failed to load tasks. Please try again later. $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create new task
  Future<bool> createTask(String title, String description) async {
    try {
      _setLoading(true);
      _clearError();
      
      final newTask = await _taskRepository.createTask(title, description);
      _tasks.add(newTask);
      
      debugPrint('Task created successfully: ${newTask.title}');
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create task. $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update existing task
  Future<bool> updateTask(Task task) async {
    try {
      _setLoading(true);
      _clearError();
      
      final updatedTask = await _taskRepository.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      
      if (index != -1) {
        _tasks[index] = updatedTask;
        debugPrint('Task updated successfully: ${updatedTask.title}');
        notifyListeners();
        return true;
      } else {
        throw Exception('Task not found in local list');
      }
    } catch (e) {
      _setError('Failed to update task. $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete task
  Future<bool> deleteTask(String taskId) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _taskRepository.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      
      debugPrint('Task deleted successfully: $taskId');
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete task. $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle task completion status
  Future<bool> toggleTaskCompletion(Task task) async {
    try {
      _setLoading(true);
      _clearError();
      
      final updatedTask = await _taskRepository.toggleTaskCompletion(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      
      if (index != -1) {
        _tasks[index] = updatedTask;
        debugPrint('Task completion toggled: ${updatedTask.title} - status: ${updatedTask.status}');
        notifyListeners();
        return true;
      } else {
        throw Exception('Task not found in local list');
      }
    } catch (e) {
      _setError('Failed to toggle task completion. $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
