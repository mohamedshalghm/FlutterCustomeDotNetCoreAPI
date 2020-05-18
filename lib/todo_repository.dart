import 'package:flutter_custom_api/todo.dart';
import 'package:flutter_custom_api/todo_provider.dart';

abstract class ITodoRepository {
  Future<List<Todo>> GetTodos(String search);
  Future<Todo> GetTodo(int id);
  Future<void> UpdateTodo(int id, Todo todo);
  Future<Todo> PostTodo(Todo todo);
  Future<Todo> DeleteTodo(int id);
}

class TodoRepository extends ITodoRepository {
  Future<List<Todo>> GetTodos(String search) async {
    return await TODOProvider.GetTodos(search);
  }
  Future<Todo> GetTodo(int id) async {
    return await TODOProvider.GetTodo(id);
  }
  Future<void> UpdateTodo(int id, Todo todo) async {
   await TODOProvider.UpdateTodo(id, todo);
  }
  Future<Todo> PostTodo(Todo todo) async {
    return await TODOProvider.PostTodoItem(todo);
  }
  Future<Todo> DeleteTodo(int id) async {
    return await TODOProvider.DeleteTodo(id);
  }
}
