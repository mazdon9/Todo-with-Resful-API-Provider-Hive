import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/services/api_service.dart';
import 'package:todo_with_resfulapi/services/storage_service.dart';

class TaskRepository {
  final ApiService _apiServie = ApiService();
  final StorageService _storageService = StorageService();
  final Connectivity _connectivity = Connectivity();

  Future<void> init() async {
    await _storageService.init();
  }

  /// Get All Tasks with offline-first approach
  Future<List<Task>> getAllTasks() async {
    try {
      // Alway try to get fresh data from API if online
      if (await _isOnline()) {
        /// Get Data from API
        final apiTasks = await _apiServie.getTasks();

        /// Clear local storage and save fresh data
        await _storageService.clearAllTasks();
        await _storageService.saveAllTasks(apiTasks);

        return apiTasks;
      } else {
        /// Get Data from Storage
        return await _storageService.getAllTasks();
      }
    } catch (e) {
      // Fallback to local storage
      return await _storageService.getAllTasks();
    }
  }

  // Check if device is online
  Future<bool> _isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
