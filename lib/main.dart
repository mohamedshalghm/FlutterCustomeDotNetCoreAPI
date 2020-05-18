import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_api/todo.dart';
import 'package:flutter_custom_api/todo_bloc/todo_bloc.dart';
import 'package:flutter_custom_api/todo_bloc/todo_events.dart';
import 'package:flutter_custom_api/todo_bloc/todo_states.dart';
import 'package:flutter_custom_api/todo_repository.dart';
import 'bloc_delegate.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dot Net Core API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(),
          child: MyHomePage(title: 'Dot net Core API - Bloc State Managment')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSwitched = true;
  TodoBloc todoBloc;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _taskTitle = TextEditingController();

  @override
  void initState() {
    todoBloc = BlocProvider.of<TodoBloc>(context);
    todoBloc.add(FetcheTodos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    //Start Details Sheet

    void TodoDetails(Todo todo) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext bc) {
            return ClipPath(
                clipper: MyCustomeCliper(),
                child: Container(
                  color: Colors.amber[100],
                  padding: EdgeInsets.only(left: 10.0, right: 3.0),
                  alignment: Alignment.center,
                  width: w,
                  height: h * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 70.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Description : ',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${todo.name}',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black45),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Task Status : ',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${todo.isComplete == 1 ? "Completed" : "Not Yet"}',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: todo.isComplete == 1
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          });
    }

    //End Details Sheet

    // Start New Todo Dialog

    void NewTodo(Todo todo) {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                content: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Container(
                          width: w,
                          height: 260,
                          child: ListView(
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.add,
                                            color: Colors.blue,
                                            size: 25.0,
                                          ),
                                          Text(
                                            'New Task',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18.0),
                                          )
                                        ],
                                      )),
                                  Divider(
                                    height: 5.0,
                                    color: Colors.blueAccent,
                                    indent: 3.0,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _taskTitle,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: "Title",
                                          hintText: "Enter Task Description",
                                        ),
                                        textInputAction: TextInputAction.next,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return "Enter task Description";
                                          }
                                          return null;
                                        },
                                      )),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SwitchListTile(
                                      value: isSwitched,
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Text(
                                        "Is Completed",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 16.0),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                        });
                                      },
                                      activeTrackColor: Colors.lightGreenAccent,
                                      activeColor: Colors.green,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      color: Colors.blue,
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          // _formKey.currentState.save();
                                          if (todo.id == 0 || todo.id == null) {
                                            todo = Todo(
                                                id: 0,
                                                name: _taskTitle.text,
                                                isComplete:
                                                    isSwitched == true ? 1 : 0);

                                            todoBloc
                                                .add(AddNewTodo(todo: todo));
                                          } else {
                                            todo.isComplete =
                                                isSwitched == true ? 1 : 0;
                                            todo.name = _taskTitle.text;

                                            todoBloc.add(UpdateTodo(
                                                todoId: todo.id, todo: todo));
                                          }

                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Container(
                                              width: w,
                                              height: 30.0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text("Saved Successfully"),
                                                  IconButton(
                                                    onPressed: () {
                                                      _scaffoldKey.currentState
                                                          .hideCurrentSnackBar();
                                                    },
                                                    icon: Icon(Icons.close),
                                                  )
                                                ],
                                              ),
                                            ),
                                            backgroundColor: Colors.green,
                                          ));

//Refresh Listview Content
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            });
          });
    }

    // End New Todo Dialog

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              todoBloc.add(FetcheTodos());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            width: w,
            height: h,
            child: ListView(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    alignment: Alignment.center,
                    color: Colors.blue[100],
                    width: w,
                    height: 60.0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.circular(50.0)),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search todos",
                            hintStyle: TextStyle(color: Colors.black26),
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.black26,
                              size: 20.0,
                            )),
                            onChanged: (val){
                              todoBloc.add(SearchTodos(search: val));
                            },
                      ),
                    )),
                SafeArea(
                    minimum: EdgeInsets.all(0.5),
                    child: BlocListener<TodoBloc,TodoState>(
                      listener: (context,state){
                          if(state is ErrorState){
                            return CommonWidget(msg: state.msg);
                          }
                      },
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is RequestingState) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is FetchedTodosState) {
                          return state.todos.length > 0
                              ? Container(
                                  width: w,
                                  height: h,
                                  child: ListView.builder(
                                    itemCount: state.todos.length,
                                    itemBuilder: (context, index) {
                                      //Start List Builder

                                      return Dismissible(
                                        onDismissed:
                                            (DismissDirection direction) {
                                          // setState(() {
                                          //   movies.removeAt(index);
                                          // });
                                        },
                                        confirmDismiss: (direction) async {
                                          if (direction ==
                                              DismissDirection.endToStart) {
                                            final bool res = await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        "Are you sure you want to delete ${state.todos[index].name}?"),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        onPressed: () {
                                                          todoBloc.add(
                                                              DeleteTodo(
                                                                  todoId: state
                                                                      .todos[
                                                                          index]
                                                                      .id));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                            return res;
                                          } else {
                                            // TODO: Navigate to edit page;
                                          }
                                        },
                                        secondaryBackground: Container(
                                          child: Center(
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                        background: Container(),
                                        child: Card(
                                          elevation: 0.2,
                                          color: Colors.blue[50],
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(state
                                                            .todos[index]
                                                            .name)),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          state.todos[index]
                                                                      .isComplete ==
                                                                  1
                                                              ? 'Completed'
                                                              : 'Not Yet',
                                                          style: TextStyle(
                                                              color: state
                                                                          .todos[
                                                                              index]
                                                                          .isComplete ==
                                                                      1
                                                                  ? Colors.green
                                                                  : Colors.red),
                                                        )),
                                                  ],
                                                ),
                                                trailing: SizedBox(
                                                    width: 70.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                            flex: 1,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    isSwitched =
                                                                        state.todos[index].isComplete ==
                                                                                1
                                                                            ? true
                                                                            : false;
                                                                    _taskTitle.text = state
                                                                        .todos[
                                                                            index]
                                                                        .name;
                                                                  });
                                                                  NewTodo(state
                                                                          .todos[
                                                                      index]);
                                                                },
                                                                child: Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  size: 25.0,
                                                                ))),
                                                        Expanded(
                                                            flex: 1,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  // setState(() {
                                                                  //   isSwitched = state.todos[index].isComplete == 1 ? true : false;
                                                                  //   _taskTitle.text = state.todos[index].name;
                                                                  // });
                                                                  // NewTodo(state.todos[index]);
                                                                  TodoDetails(
                                                                      state.todos[
                                                                          index]);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 25.0,
                                                                ))),
                                                      ],
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                        key: UniqueKey(),
                                        direction: DismissDirection.endToStart,
                                      );

                                      //Edn list Builder
                                    },
                                  ))
                              : CommonWidget(
                                  msg: "No Available Todos",
                                );
                        }

                        return Container();
                      },
                    )))
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Custome Widget to Add New Todo
          //Clear Filed
          _taskTitle.text = "";
          isSwitched = false;
          Todo todo = Todo();
          NewTodo(todo);
        },
        tooltip: 'New TODO',
        child: Icon(Icons.add),
      ),
    );
  }
}

//Todo Action

class CommonWidget extends StatelessWidget {
  CommonWidget({this.msg});

  String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.65,
      alignment: Alignment.center,
      child: Text(msg, style: TextStyle(color: Colors.red, fontSize: 18.0)),
    );
  }
}

class MyCustomeCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //height: h * 0.3,
    double w = size.width;
    double h = size.height;
    Path path = Path();
    path.moveTo(0, h * 0.5);
    path.lineTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w, h * 0.5);
    path.quadraticBezierTo(w * 0.5, 0, 0, h * 0.5);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
