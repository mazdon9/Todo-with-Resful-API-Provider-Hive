import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_with_resfulapi/models/tasks.dart';

class StorageService {
  static const String _TaskBoxName = 'tasks';
  late Box<Task> _TaskBox;
  // initialization of the box
  Future<void> init() async {
    debugPrint('Initializing StorageService...');
    _TaskBox = await Hive.openBox<Task>(_TaskBoxName);
    debugPrint('StorageService initialized with box: $_TaskBoxName');
  }

  // save a task
  Future<void> saveAllTasks(List<Task> tasks) async {
    debugPrint('Saving ${tasks.length} tasks to storage...');
    final Map<String, Task> TaskMap = {};
    for (final task in tasks) {
      final key = task.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      TaskMap[key] = task.copyWith(id: key);
    }
    await _TaskBox.putAll(TaskMap);
    debugPrint('All tasks saved successfully.');
  }

  // get all tasks
  Future<List<Task>> getAllTasks() async {
    final tasks = _TaskBox.values.toList();
    return tasks;
  }

  //clear all tasks
  Future<void> clearAllTasks() async {
    await _TaskBox.clear();
    debugPrint('All tasks cleared from storage.');
  }
}
