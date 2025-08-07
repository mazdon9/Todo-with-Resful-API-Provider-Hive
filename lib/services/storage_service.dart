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

  // add task local to hive and sync later
  Future<Task> addTaskLocal(String title, String description) async {
    try {
      final taskId = 'local_${DateTime.now().microsecondsSinceEpoch}';
      // Create a new task
      final newTask = Task(
        id: taskId,
        title: title,
        description: description,
        status: 'pendiente',
      );
      // save task to hive
      await _taskBox.put(taskId, newTask);
      // add to sync queue for sync later
      await _addToSyncQueue('create', newTask);
      debugPrint('task added Locally: $title');
      return newTask;
    } catch (e) {
      debugPrint('Error adding task locally: $e');
      throw Exception('Failed to add task locally: $e');
    }
  }

  // edit task local when offline
  Future<Task> editTaskLocal(Task updateTask) async {
    try {
      if (updateTask.id == null) {
        throw Exception('Task ID is required for editing');
      }
      // Update the task in Hive
      await _taskBox.put(updateTask.id, updateTask);

      // add to sync queue for sync later
      await _addToSyncQueue('update', updateTask);
      debugPrint('Task edited locally: ${updateTask.title}');
      return updateTask;
    } catch (e) {
      debugPrint('Error editing task locally: $e');
      throw Exception('Failed to edit task locally: $e');
    }
  }

  // delete task local when offline
  Future<void> deleteTaskLocal(String taskId) async {
    try {
      // check if task exists
      final existingTask = _taskBox.get(taskId);
      if (existingTask == null) {
        throw Exception('Task with ID $taskId does not exist');
      }
      // Delete the task from Hive
      await _taskBox.delete(taskId);
      // add to sync queue for sync later
      await _addToSyncQueue('delete', existingTask);
      debugPrint('Task deleted locally: $taskId');
    } catch (e) {
      debugPrint('Error deleting task locally: $e');
      throw Exception('Failed to delete task locally: $e');
    }
  }

  // toggle task completion status locally
  Future<Task> toggleTaskCompletedLocal(Task task) async {
    try {
      if (task.id == null) {
        throw Exception('Task ID is required for toggling completion');
      }
      // Toggle the task status completion
      final updatedTask = task.copyWith(
        status: task.isPending ? 'completada' : 'pendiente',
      );
      // Update the task in Hive
      await _taskBox.put(task.id!, updatedTask);

      //add to sync queue for sync later
      await _addToSyncQueue('update', updatedTask);
      debugPrint('Task completion toggled locally: ${task.title}');
      return updatedTask;
    } catch (e) {
      debugPrint('Error toggling task completion locally: $e');
      throw Exception('Failed to toggle task completion locally: $e');
    }
  }

  // add operation to sync queue
  Future<void> _addToSyncQueue(String operation, Task task) async {
    try {
      final syncItem = {
        'operation': operation,
        'task': task.toJson(),
        'timestamp': DateTime.now().microsecondsSinceEpoch,
        'synced': false,
      };
      debugPrint('Adding to sync queue: $syncItem');
      // create key for sync queue
      final syncKey =
          '${operation}_${task.id}_${DateTime.now().microsecondsSinceEpoch}';
      await _syncQueueBox.put(syncKey, syncItem);
      debugPrint('Added to sync queue: $syncItem');
    } catch (e) {
      debugPrint('Error adding to sync queue: $e');
      throw Exception('Failed to add to sync queue: $e');
    }
  }

  // get pending sync operations ( use for syncing later )
  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async {
    try {
      final allSyncItems = _syncQueueBox.values.toList();
      final pendingSyncItems =
          allSyncItems
              .where((item) => item['synced'] == false)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();

      debugPrint('Pending sync operations loaded successfully');
      return pendingSyncItems;
    } catch (e) {
      debugPrint('Error loading pending sync operations: $e');
      return [];
    }
  }

  // mark sync or operation as synced (use after successful sync)
  Future<void> markSyncOperationCompleted(String synckey) async {
    try {
      final syncItem = _syncQueueBox.get(synckey);
      if (syncItem != null) {
        syncItem['synced'] = true;
        await _syncQueueBox.put(synckey, syncItem);
        debugPrint('Sync operation marked as completed: $synckey');
      } else {
        debugPrint('Sync key not found: $synckey');
      }
    } catch (e) {
      debugPrint('Error marking sync operation as completed: $e');
      throw Exception('Failed to mark sync operation as completed: $e');
    }
  }

  // clear completed sync operations
  Future<void> clearCompledSyncOperations() async {
    try {
      final allkeys = _syncQueueBox.keys.toList();
      for (final key in allkeys) {
        final syncItem = _syncQueueBox.get(key);
        if (syncItem != null && syncItem['synced'] == true) {
          await _syncQueueBox.delete(key);
        }
      }
      debugPrint('Completed sync operations cleared successfully');
    } catch (e) {
      debugPrint('Error clearing completed sync operations: $e');
      throw Exception('Failed to clear completed sync operations: $e');
    }
  }

  /// Get single task by ID
  Future<Task?> getTaskById(String taskId) async {
    try {
      return _taskBox.get(taskId);
    } catch (e) {
      debugPrint('Error getting task by ID: $e');
      return null;
    }
  }

  /// Check if task exists locally
  Future<bool> taskExists(String taskId) async {
    return _taskBox.containsKey(taskId);
  }

  /// Get tasks count
  Future<int> getTasksCount() async {
    return _taskBox.length;
  }

  /// Clear all local tasks (Use with caution)
  Future<void> clearAllTasks() async {
    try {
      await _taskBox.clear();
      debugPrint('All local tasks cleared');
    } catch (e) {
      debugPrint('Error clearing all tasks: $e');
    }
  }
}
