import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/services/api_service.dart';
import 'package:todo_with_resfulapi/services/storage_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final Connectivity _connectivity = Connectivity();

  /// Init StorageService
  Future<void> init() async {
    await _storageService.init();
  }

  /// Get all tasks from the API or local hive
  Future<List<Task>> getAllTasks() async {
    try {
      if (await _isOnline()) {
        /// Get tasks from api and later save to local
        final tasks = await _apiService.getAllTasks();
        await _storageService.saveAllTasks(tasks);
        return tasks;
      } else {
        /// Get tasks from local hive
        return await _storageService.getAllTasks();
      }
    } catch (e) {
      debugPrint('Error fetching tasks in TaskRepository: $e');
      return await _storageService.getAllTasks();
    }
  }

  /// Create new task
  Future<Task> createTask(String title, String description) async {
    try {
      if (await _isOnline()) {
        /// Online: Tạo task qua API
        await _apiService.createTask(title, description);

        /// Sau khi tạo thành công, reload tất cả tasks từ API để có ID chính xác
        final allTasks = await _apiService.getAllTasks();
        await _storageService.saveAllTasks(allTasks);

        /// Tìm task vừa tạo (thường là task cuối cùng với title/description khớp)
        final createdTask = allTasks.lastWhere(
          (task) => task.title == title && task.description == description,
          orElse:
              () => Task(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                title: title,
                description: description,
                status: 'pendiente',
              ),
        );

        debugPrint('Task created online: ${createdTask.title}');
        return createdTask;
      } else {
        /// Offline: Tạo task local và thêm vào sync queue
        final newTask = await _storageService.addTaskLocal(title, description);
        debugPrint('Task created offline: ${newTask.title}');
        return newTask;
      }
    } catch (e) {
      debugPrint('Error creating task in Repository: $e');

      /// Nếu API fail, thử tạo local
      try {
        final newTask = await _storageService.addTaskLocal(title, description);
        debugPrint('Task created offline (fallback): ${newTask.title}');
        return newTask;
      } catch (localError) {
        debugPrint('Error creating task locally: $localError');
        throw Exception('Repository: Failed to create task - $e');
      }
    }
  }

  /// Update existing task
  Future<Task> updateTask(Task task) async {
    try {
      if (await _isOnline()) {
        /// Online: Cập nhật qua API
        await _apiService.updateTask(task);

        /// Cập nhật local storage
        await _storageService.editTaskLocal(task);

        debugPrint('Task updated online: ${task.title}');
        return task;
      } else {
        /// Offline: Cập nhật local và thêm vào sync queue
        final updatedTask = await _storageService.editTaskLocal(task);
        debugPrint('Task updated offline: ${updatedTask.title}');
        return updatedTask;
      }
    } catch (e) {
      debugPrint('Error updating task in Repository: $e');

      /// Nếu API fail, thử update local
      try {
        final updatedTask = await _storageService.editTaskLocal(task);
        debugPrint('Task updated offline (fallback): ${updatedTask.title}');
        return updatedTask;
      } catch (localError) {
        debugPrint('Error updating task locally: $localError');
        throw Exception('Repository: Failed to update task - $e');
      }
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      if (await _isOnline()) {
        /// Online: Xóa qua API
        await _apiService.deleteTask(taskId);

        /// Xóa khỏi local storage
        await _storageService.deleteTaskLocal(taskId);

        debugPrint('Task deleted online: $taskId');
      } else {
        /// Offline: Xóa local và thêm vào sync queue
        await _storageService.deleteTaskLocal(taskId);
        debugPrint('Task deleted offline: $taskId');
      }
    } catch (e) {
      debugPrint('Error deleting task in Repository: $e');

      /// Nếu API fail, thử delete local
      try {
        await _storageService.deleteTaskLocal(taskId);
        debugPrint('Task deleted offline (fallback): $taskId');
      } catch (localError) {
        debugPrint('Error deleting task locally: $localError');
        throw Exception('Repository: Failed to delete task - $e');
      }
    }
  }

  /// Toggle task completion status
  Future<Task> toggleTaskCompletion(Task task) async {
    try {
      if (await _isOnline()) {
        /// Online: Toggle qua API
        final updatedTask = Task(
          id: task.id,
          title: task.title,
          description: task.description,
          status: task.isPending ? 'completada' : 'pendiente',
        );

        await _apiService.updateTask(updatedTask);

        /// Cập nhật local storage
        final toggledTask = await _storageService.toggleTaskCompletedLocal(
          task,
        );

        debugPrint(
          'Task completion toggled online: ${toggledTask.title} - ${toggledTask.status}',
        );
        return toggledTask;
      } else {
        /// Offline: Toggle local và thêm vào sync queue
        final toggledTask = await _storageService.toggleTaskCompletedLocal(
          task,
        );
        debugPrint(
          'Task completion toggled offline: ${toggledTask.title} - ${toggledTask.status}',
        );
        return toggledTask;
      }
    } catch (e) {
      debugPrint('Error toggling task completion in Repository: $e');

      /// Nếu API fail, thử toggle local
      try {
        final toggledTask = await _storageService.toggleTaskCompletedLocal(
          task,
        );
        debugPrint(
          'Task completion toggled offline (fallback): ${toggledTask.title}',
        );
        return toggledTask;
      } catch (localError) {
        debugPrint('Error toggling task completion locally: $localError');
        throw Exception('Repository: Failed to toggle task completion - $e');
      }
    }
  }

  /// Get single task by ID
  Future<Task?> getTaskById(String taskId) async {
    try {
      return await _storageService.getTaskById(taskId);
    } catch (e) {
      debugPrint('Error getting task by ID in Repository: $e');
      return null;
    }
  }

  /// Check if task exists
  Future<bool> taskExists(String taskId) async {
    try {
      return await _storageService.taskExists(taskId);
    } catch (e) {
      debugPrint('Error checking task existence in Repository: $e');
      return false;
    }
  }

  /// Get tasks count
  Future<int> getTasksCount() async {
    try {
      return await _storageService.getTasksCount();
    } catch (e) {
      debugPrint('Error getting tasks count in Repository: $e');
      return 0;
    }
  }

  /// Get pending sync operations (để UI hiển thị trạng thái sync)
  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async {
    try {
      return await _storageService.getPendingSyncOperations();
    } catch (e) {
      debugPrint('Error getting pending sync operations in Repository: $e');
      return [];
    }
  }

  /// Force sync all pending operations (sẽ implement sau)
  Future<void> syncPendingOperations() async {
    try {
      if (!await _isOnline()) {
        debugPrint('Cannot sync: No internet connection');
        return;
      }

      final pendingOperations =
          await _storageService.getPendingSyncOperations();
      debugPrint(
        'Found ${pendingOperations.length} pending operations to sync',
      );

      // Implement sync logic here
      for (final operation in pendingOperations) {
        try {
          final operationType = operation['operation'] as String;
          final taskData = operation['task'] as Map<String, dynamic>;
          final timestamp = operation['timestamp'] as int;

          debugPrint(
            'Syncing operation: $operationType for task: ${taskData['title']}',
          );

          switch (operationType) {
            case 'create':
              // Sync create operation
              await _apiService.createTask(
                taskData['title'] as String,
                taskData['description'] as String,
              );
              break;

            case 'update':
              // Sync update operation
              final task = Task(
                id: taskData['id'] as String?,
                title: taskData['title'] as String,
                description: taskData['description'] as String,
                status: taskData['status'] as String,
              );

              // Chỉ sync nếu task không phải local (có ID thật từ server)
              if (task.id != null && !task.id!.startsWith('local_')) {
                await _apiService.updateTask(task);
              }
              break;

            case 'delete':
              // Sync delete operation
              final taskId = taskData['id'] as String?;
              if (taskId != null && !taskId.startsWith('local_')) {
                await _apiService.deleteTask(taskId);
              }
              break;
          }

          // Mark operation as completed
          final syncKey = '${operationType}_${taskData['id']}_$timestamp';
          await _storageService.markSyncOperationCompleted(syncKey);

          debugPrint(
            'Successfully synced: $operationType - ${taskData['title']}',
          );
        } catch (e) {
          debugPrint(
            'Failed to sync operation: ${operation['operation']} - $e',
          );
          // Tiếp tục với operations khác thay vì dừng
          continue;
        }
      }

      // Sau khi sync xong, reload data từ API và clear completed operations
      final allTasks = await _apiService.getAllTasks();
      await _storageService.saveAllTasks(allTasks);
      await _storageService.clearCompledSyncOperations();

      debugPrint('Sync completed successfully');
    } catch (e) {
      debugPrint('Error syncing pending operations: $e');
      throw Exception('Failed to sync pending operations: $e');
    }
  }

  /// Check internet connectivity
  Future<bool> _isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Repository: Failed to check internet connection - $e');
      return false;
    }
  }

  /// Check if online (public method for UI)
  Future<bool> isOnline() async {
    return await _isOnline();
  }

  /// Clear all tasks (for testing/debugging)
  Future<void> clearAllTasks() async {
    try {
      await _storageService.clearAllTasks();
      debugPrint('All tasks cleared from Repository');
    } catch (e) {
      debugPrint('Error clearing all tasks in Repository: $e');
    }
  }
}
