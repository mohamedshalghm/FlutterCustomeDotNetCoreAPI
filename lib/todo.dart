class Todo {
  int id;
  String name;
  int isComplete;

  Todo({this.id, this.name, this.isComplete});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isComplete = json['isComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.id != 0){
      data['id'] = this.id;
    }
    data['name'] = this.name;
    data['isComplete'] = this.isComplete;
    return data;
  }
  
}

class TodoList{
  List<Todo> todos;
  TodoList({this.todos});
  factory TodoList.fromJson(List<dynamic> parsedJson){
    return TodoList(
      todos: parsedJson.map((todo) => Todo.fromJson(todo)).toList()
    );
  }
}
