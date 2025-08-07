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

  Future<void> init() async {
    try {
      _setLoading(true);
      _clearError();
      await _taskRepository.init();
      await loadTasks();
    } catch (e) {
      _setError('Failed to init $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get All Tasks From Repository
  Future<void> loadTasks() async {
    try {
      _setLoading(true);
      _clearError();
      _tasks = await _taskRepository.getAllTasks();

      notifyListeners();

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
  Future<void> createTask(String title, String description) async {
    try {
      _setLoading(true);
      _clearError();

      await _taskRepository.createTask(title, description);
      _tasks = await _taskRepository.getAllTasks();

      debugPrint('Task created successfully: ${pendingTasks.length}');
      notifyListeners();
    } catch (e) {
      _setError('Failed to create task. $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update existing task
  Future<void> updateTask(Task task) async {
    try {
      _clearError();
      _setLoading(true);

      await _taskRepository.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);

      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          title: task.title,
          description: task.description,
        );
        final updatedTask = _tasks[index];
        debugPrint('Task updated successfully: ${updatedTask.title}');
        notifyListeners();
      } else {
        throw Exception('Task not found in local list');
      }
    } catch (e) {
      _setError('Failed to update task. $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      _clearError();
      _setLoading(true);

      await _taskRepository.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);

      debugPrint('Task deleted successfully: $taskId');
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete task. $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(Task task) async {
    try {
      _clearError();
      _setLoading(true);

      await _taskRepository.toggleTaskCompletion(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);

      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          status: _tasks[index].isPending ? 'completada' : 'pendiente',
        );
        final updatedTask = _tasks[index];
        debugPrint(
          'Task completion toggled: ${updatedTask.title} - status: ${updatedTask.status}',
        );
        notifyListeners();
      } else {
        _setError('Task not found in local list');
      }
    } catch (e) {
      _setError('Failed to toggle task completion. $e');
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
