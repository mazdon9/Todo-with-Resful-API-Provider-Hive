import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/reponsitories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize the provider
  Future<void> init() async {
    debugPrint('TaskProvider: Initializing...');
    await loadTasks();
  }

  /// Load all tasks from the repository
  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('TaskProvider: Loading tasks...');
      final tasks = await _taskRepository.getAllTasks();
      debugPrint('TaskProvider: Successfully loaded ${tasks.length} tasks');

      _tasks = tasks;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('TaskProvider Error: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
