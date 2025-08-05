import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/reponsitories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();
  late List<Task> _tasks;
  List<Task> get tasks => _tasks;
  List<Task> get completedTasks =>
      _tasks.where((task) => task.isPending).toList();
  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;

  // get all tasks form repository
  Future<void> LoadTasks() async {
    try {
      _setLoading(true);
      _tasks = await _taskRepository.getAllTasks();
      debugPrint('Tasks loaded: ${_tasks.length}');
      debugPrint(
        'tasks: pending: ${_tasks.where((task) => task.isPending).length}',
      );
    } catch (e) {
      _setError('Failed to load tasks: $e');
    } finally {
      _setLoading(false);
    }
  }

  // setloading state
  void _setLoading(bool loading) {
    if (loading != _isLoading) {
      notifyListeners();
    }
  }

  // set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
}
