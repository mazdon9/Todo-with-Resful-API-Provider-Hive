import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_with_resfulapi/models/tasks.dart';
import 'package:todo_with_resfulapi/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();
  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;
  bool get hasError => _error != null;

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();
  bool _innitialized = false;
  Future<void> init() async {
    if (_innitialized) {
      debugPrint('TaskProvider is already initialized.');
      return;
    }
    try {
      _setLoading(true);
      await _taskRepository.init();
      // load tasks from repository
      await loadTasks();
      _innitialized = true;
      debugPrint('TaskProvider initialized successfully.');
    } catch (e) {
      _error = 'Failed to initialize TaskProvider: $e';
      debugPrint(_error);
      return;
    }
  }

  // load tasks from repository
  Future<void> loadTasks() async {
    try {
      _clearError();
      _setLoading(true);
      // GET tasks from repository
      final LoaderTasks = await _taskRepository.getAllTasks();
      _tasks.clear();
      _tasks.addAll(LoaderTasks);
      debugPrint('Tasks loaded successfully: ${_tasks.length} tasks');
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

  void _setError(String? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
