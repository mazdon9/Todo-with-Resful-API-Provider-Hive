import 'package:flutter/material.dart';

import 'package:todo_with_resfulapi/models/todo_model.dart';
import 'package:todo_with_resfulapi/services/todo_api_service.dart';

enum LoadingStatus { idle, loading, success, error }

class TodoProvider extends ChangeNotifier {
  final TodoApiService _apiService = TodoApiService();

  List<TodoModel> _todos = [];
  List<TodoModel> get todos => _todos;

  List<TodoModel> _completedTodos = [];
  List<TodoModel> get completedTodos => _completedTodos;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  LoadingStatus _status = LoadingStatus.idle;
  LoadingStatus get status => _status;

  TodoProvider() {
    // fetchTodos();
    _loadDummyData(); // Tạm thời sử dụng dữ liệu giả để test
  }

  // Tạo dữ liệu giả để test UI
  void _loadDummyData() {
    _todos = [
      TodoModel(id: '1', title: 'TODO TITLE', detail: 'TODO SUB TITLE'),
      TodoModel(id: '2', title: 'TODO TITLE', detail: 'TODO SUB TITLE'),
      TodoModel(id: '3', title: 'TODO TITLE', detail: 'TODO SUB TITLE'),
    ];
    _completedTodos = [
      TodoModel(
        id: '4',
        title: 'TODO TITLE',
        detail: 'TODO SUB TITLE',
        isCompleted: true,
      ),
      TodoModel(
        id: '5',
        title: 'TODO TITLE',
        detail: 'TODO SUB TITLE',
        isCompleted: true,
      ),
    ];
    _status = LoadingStatus.success;
    notifyListeners();
  }

  // Fetch all todos from API
  Future<void> fetchTodos() async {
    _status = LoadingStatus.loading;
    notifyListeners();

    try {
      final allTodos = await _apiService.getTodos();
      _todos = allTodos.where((todo) => !todo.isCompleted).toList();
      _completedTodos = allTodos.where((todo) => todo.isCompleted).toList();
      _status = LoadingStatus.success;
    } catch (e) {
      print('Error fetching todos: $e');
      _errorMessage = e.toString();
      _status = LoadingStatus.error;
    }

    notifyListeners();
  }

  // Add new todo
  Future<void> addTodo(TodoModel todo) async {
    _status = LoadingStatus.loading;
    notifyListeners();

    try {
      // Tạm thời bỏ gọi API và làm việc với dữ liệu local
      // final newTodo = await _apiService.createTodo(todo);
      // Tạo ID giả
      todo.id = DateTime.now().millisecondsSinceEpoch.toString();
      _todos.add(todo);
      _status = LoadingStatus.success;
    } catch (e) {
      print('Error adding todo: $e');
      _errorMessage = e.toString();
      _status = LoadingStatus.error;
    }

    notifyListeners();
  }

  // Update todo
  Future<void> updateTodo(TodoModel todo) async {
    _status = LoadingStatus.loading;
    notifyListeners();

    try {
      // Tạm thời bỏ gọi API
      // await _apiService.updateTodo(todo.id, todo);

      if (todo.isCompleted) {
        _todos.removeWhere((t) => t.id == todo.id);
        _completedTodos.add(todo);
      } else {
        final index = _todos.indexWhere((t) => t.id == todo.id);
        if (index >= 0) {
          _todos[index] = todo;
        } else {
          final completedIndex = _completedTodos.indexWhere(
            (t) => t.id == todo.id,
          );
          if (completedIndex >= 0) {
            _completedTodos.removeAt(completedIndex);
            _todos.add(todo);
          }
        }
      }

      _status = LoadingStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = LoadingStatus.error;
    }

    notifyListeners();
  }

  // Toggle todo status
  Future<void> toggleTodoStatus(TodoModel todo) async {
    todo.isCompleted = !todo.isCompleted;
    await updateTodo(todo);
  }

  // Delete todo
  Future<void> deleteTodo(TodoModel todo) async {
    _status = LoadingStatus.loading;
    notifyListeners();

    try {
      // Tạm thời bỏ gọi API
      // await _apiService.deleteTodo(todo.id);

      _todos.removeWhere((t) => t.id == todo.id);
      _completedTodos.removeWhere((t) => t.id == todo.id);
      _status = LoadingStatus.success;
    } catch (e) {
      print('Error deleting todo: $e');
      _errorMessage = e.toString();
      _status = LoadingStatus.error;
    }

    notifyListeners();
  }
}
