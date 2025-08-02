import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:todo_with_resfulapi/models/task.dart';

class StorageService {
  static const String _taskBoxName = 'tasks';

  late Box<Task> _taskBox;

  // Initialize Hive boxes
  Future<void> init() async {
    debugPrint('Initializing Storage service....');
    _taskBox = await Hive.openBox<Task>(_taskBoxName);
    debugPrint('Done Initialize Storage service....');
  }

  // Save All Tasks
  Future<void> saveAllTasks(List<Task> tasks) async {
    debugPrint('Saving All Tasks to Storage service....');
    final Map<String, Task> taskMap = {};

    for (final task in tasks) {
      final key = task.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      taskMap[key] = task.copyWith(id: key);
    }

    await _taskBox.putAll(taskMap);
    debugPrint('All Tasks Saved to Storage service....');
  }

  // Get All Tasks
  Future<List<Task>> getAllTasks() async {
    final task = _taskBox.values.toList();
    return task;
  }

  // Clear All Tasks in local
  Future<void> clearAllTasks() async {
    await _taskBox.clear();
  }
}
