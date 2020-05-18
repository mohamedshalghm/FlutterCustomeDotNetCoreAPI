import 'package:equatable/equatable.dart';
import 'package:flutter_custom_api/todo.dart';

abstract class TodoState extends Equatable {}

class InitialState extends TodoState {
  @override
  List<Object> get props => [];
}

class ErrorState extends TodoState {
  String msg;
  @override
  ErrorState({this.msg});
  List<Object> get props => [msg];
}

class RequestingState extends TodoState {
  @override
  List<Object> get props => [];
}

class FetchedTodosState extends TodoState {
  List<Todo> todos;
  FetchedTodosState({this.todos});
  @override
  List<Object> get props => [todos];
}

class FetchedTodoState extends TodoState {
  Todo todo;
  FetchedTodoState({this.todo});
  @override
  List<Object> get props => [todo];
}

class PostedTodoState extends TodoState {
  Todo todo;
  PostedTodoState({this.todo});
  @override
  List<Object> get props => [todo];
}

class UpdatedTodoState extends TodoState {
  @override
  List<Object> get props => [];
}

class DeletedTodoState extends TodoState {
  Todo todo;
  DeletedTodoState({this.todo});
  @override
  List<Object> get props => [todo];
}
