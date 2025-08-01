import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool get hasError => _error != null;

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks =>
      _tasks.where((task) => task.isPending).toList();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      debugPrint('TaskProvider already initialized');
      return;
    }

    try {
      _setLoading(true);

      await _taskRepository.init();

      /// Load Tasks
      await loadTasks();
      _initialized = true;
    } catch (e) {
      _setError('Failed to initialize TaskProvider: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load Tasks from Repository
  Future<void> loadTasks() async {
    try {
      _clearError();
      _setLoading(true);

      // GET TASKS
      final loadedTasks = await _taskRepository.getAllTasks();

      _tasks = loadedTasks;
      debugPrint('Loaded ${_tasks.length} tasks from Repository');
      notifyListeners();
    } catch (e) {
      _setError('Failed to load tasks: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
