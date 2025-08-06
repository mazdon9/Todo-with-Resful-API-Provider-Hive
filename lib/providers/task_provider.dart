import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  List<Task> get pendingTasks =>
      _tasks.where((task) => task.isPending).toList();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool get hasError => _error != null;

  /// Get All Tasks From Repository
  Future<void> loadTasks() async {
    try {
      _setLoading(true);
      _tasks = await _taskRepository.getAllTasks();

      /// Log
      debugPrint('Tasks Loaded Successfully');
      debugPrint('Tasks Loaded with length: ${_tasks.length}');
      debugPrint(
        'Tasks Loaded pendingTasks with length: ${pendingTasks.length}',
      );
    } catch (e) {
      _setError('Failed to load tasks. Please try again later. $e');
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
}
