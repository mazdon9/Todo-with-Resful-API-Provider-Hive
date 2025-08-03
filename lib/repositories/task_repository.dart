import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todo_with_resfulapi/models/tasks.dart';
import 'package:todo_with_resfulapi/services/api_service.dart';
import 'package:todo_with_resfulapi/services/storage_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final Connectivity _connectivity = Connectivity();

  Future<void> init() async {
    await _storageService.init();
  }

  Future<List<Task>> getAllTasks() async {
    try {
      // Check if device is online
      if (await isOnline()) {
        // Fetch data from API
        final apiTasks = await _apiService.getTasks();
        // clear local storage and save new tasks

        return apiTasks;
      } else {
        // fetch data from local storage
        return _storageService.getAllTasks();
      }
      // if the local storage is empty, fetch from API
    } catch (e) {
      // Optionally log the error
      print('Error fetching tasks: $e');
      return await _storageService.getAllTasks();
    }
  }

  // check if device is online
  Future<bool> isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      return true;
    } catch (e) {
      print('Error checking online status: $e');
      return false;
    }
  }
}
