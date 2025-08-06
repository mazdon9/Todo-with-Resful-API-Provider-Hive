import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_with_resfulapi/models/task.dart';

class StorageService {
  static const String _taskBoxName = 'tasks';
  static const String _syncQueueBoxName = 'syncQueue';

  late Box<Task> _taskBox;
  late Box<Map> _syncQueueBox;

  // Initilize Hive boxes
  Future<void> init() async {
    debugPrint('Initializing Hive boxes');
    _taskBox = await Hive.openBox<Task>(_taskBoxName);
    _syncQueueBox = await Hive.openBox<Map>(_syncQueueBoxName);
    debugPrint('Hive boxes initialized successfully');
  }

  /// Save all tasks to the Hive box
  Future<void> saveAllTasks(List<Task> tasks) async {
    /// Clear all data from the Hive box before saving
    await _taskBox.clear();

    /// Saving to local
    final Map<String, Task> taskMap = {};

    for (final task in tasks) {
      final key = task.id ?? DateTime.now().microsecondsSinceEpoch.toString();
      taskMap[key] = task.copyWith(id: key);
    }
    await _taskBox.putAll(taskMap);
    debugPrint('Tasks saved successfully');
  }

  /// Get all tasks from the Hive box
  Future<List<Task>> getAllTasks() async {
    final tasks = _taskBox.values.toList();
    debugPrint('Tasks loaded successfully');
    return tasks;
  }
}
