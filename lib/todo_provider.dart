import 'dart:async' show Future;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_custom_api/todo.dart';
import 'package:http/http.dart' as http;

class TODOProvider{
  
// String get hostname {
//   if (kIsWeb) {
//     return 'http://localhost:8888';
//   } else if (Platform.isAndroid) {
//     return 'http://10.0.2.2:8888';
//   } else {
//     return 'http://localhost:8888';
//   }
// }

static String url = "http://192.168.8.102:5000/api/";

static Map<String, String> headers = {
  'Content-Type': 'application/json',
  };
// GET: api/TodoItems
// Search //?search=test
static Future<List<Todo>> GetTodos(String search) async{
  var todosUrl = Uri.encodeFull(url+"TodoItems");
  if(search.isNotEmpty){
    todosUrl = Uri.encodeFull(url+"TodoItems?search="+search);
  }
  print(todosUrl);
  var response = await http.get(todosUrl,headers: headers);
  if (response.statusCode == 200) {
    TodoList todoList = TodoList.fromJson(json.decode(response.body));
    return todoList.todos;
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
}

 // GET: api/TodoItems/5
static Future<Todo> GetTodo(int id) async{
  var todoUrl = Uri.encodeFull(url+"TodoItems/"+id.toString());
  var response = await http.get(todoUrl,headers: headers);
  if (response.statusCode == 200) {
    Todo todo = Todo.fromJson(json.decode(response.body));
    return todo;
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
}

 //PUT: api/TodoItems/5
static Future<void> UpdateTodo(int id, Todo todo) async{
  var todoUrl = Uri.encodeFull(url+"TodoItems/"+id.toString());
  // var response = await http.put(todoUrl,headers: headers,body: todo);

  var response = await http.put(
    todoUrl,
    body: jsonEncode(todo),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    Todo todo = Todo.fromJson(json.decode(response.body));
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
}

// POST: api/TodoItems
static Future<Todo> PostTodoItem(Todo todo) async{
  print(jsonEncode(todo));
  var todoUrl = Uri.encodeFull(url+"TodoItems");
  var response = await http.post(
    todoUrl,
    body: jsonEncode(todo),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    Todo todo = Todo.fromJson(json.decode(response.body));
    return todo;
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
}

// DELETE: api/TodoItems/5
static Future<Todo> DeleteTodo(int id) async{
  var todoUrl = Uri.encodeFull(url+"TodoItems/"+id.toString());
  var response = await http.delete(todoUrl,headers: headers);
  if (response.statusCode == 200) {
    Todo todo = Todo.fromJson(json.decode(response.body));
    return todo;
  } else {
    print("Request failed with status: ${response.statusCode}.");
  }
}

}

