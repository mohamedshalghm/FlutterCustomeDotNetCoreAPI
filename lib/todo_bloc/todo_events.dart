import 'package:equatable/equatable.dart';
import 'package:flutter_custom_api/todo.dart';

abstract class TodoEvent extends Equatable {}

class FetcheTodos extends TodoEvent {
  @override
  List<Object> get props => [];
}

class FetcheTodo extends TodoEvent {
  int todoId;
  FetcheTodo({this.todoId});
  @override
  List<Object> get props => [todoId];
}

class AddNewTodo extends TodoEvent {
  Todo todo;
  AddNewTodo({this.todo});
  @override
  List<Object> get props => [todo];
}

class UpdateTodo extends TodoEvent {
  int todoId;
  Todo todo;
  UpdateTodo({this.todoId, this.todo});
  @override
  List<Object> get props => [todoId, todo];
}

class DeleteTodo extends TodoEvent {
  int todoId;
  DeleteTodo({this.todoId});
  @override
  List<Object> get props => [todoId];
}

class SearchTodos extends TodoEvent {
  String search;
  SearchTodos({this.search});
  @override
  List<Object> get props => [search];
}
