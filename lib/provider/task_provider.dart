import 'package:flutter/widgets.dart';
import 'package:todo_with_resfulapi/models/tasks.dart';
import 'package:todo_with_resfulapi/repositories/task_repository.dart';

class TaskProvider {
  final TaskRepository _taskRepository = TaskRepository();
  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;
  bool get hasError => _error != null;

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();
  final bool _innitialized = false;
  Future<void> init() async {
    if (_innitialized) {
      debugPrint('TaskProvider is already initialized.');
      return;
    }
    try {} catch (e) {
      _error = 'Failed to initialize TaskProvider: $e';
      debugPrint(_error);
      return;
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    debugPrint('Loading state changed: $_isLoading');
  }

  void setError(String error) {
    _error = error;
    debugPrint('Error set: $_error');
  }

  void clearError() {
    _error = null;
    debugPrint('Error cleared');
  }
}
