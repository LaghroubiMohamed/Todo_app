import 'package:flutter/material.dart';
import 'package:todo_app/DataBase/database_helper.dart';
import 'package:todo_app/Models/task.dart';
import 'package:todo_app/Models/todo.dart';
import 'package:todo_app/pages/HomePage.dart';
import 'package:todo_app/widgets/TodoCheckWidget.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // ? add field to sqlite data base
  DatabaseHelper _dbhelper = DatabaseHelper();
  String _tasktitle = '';
  String _taskDescription = '';

  int _taskId = 0;

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _isvisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      _isvisible = true;
      _taskDescription = widget.task.description;
      _tasktitle = widget.task.title;
      _taskId = widget.task.id;
    }
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom: 6,
                    ),
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          splashColor: Color(0xFF7349FE),
                          child: Image(
                              image: AssetImage(
                                  "assets/images/back_arrow_icon.png")),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        focusNode: _titleFocus,
                        onSubmitted: (value) async {
                          //? Check if the field is empty
                          if (value != '') {
                            //Check if the task is null
                            if (widget.task == null) {
                              Task _newTask = Task(
                                title: value,
                              );
                              _taskId = await _dbhelper.insertTask(_newTask);
                              setState(() {
                                _isvisible = true;
                                _tasktitle = value;
                              });
                            } else {
                              await _dbhelper.updatetasktitle(_taskId, value);
                              print('task title updated');
                            }
                            _descriptionFocus.requestFocus();
                          }
                        },
                        controller: TextEditingController()..text = _tasktitle,
                        decoration: InputDecoration(
                          hintText: 'Enter Task Title',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211551)),
                      ))
                    ]),
                  ),
                  Visibility(
                    visible: _isvisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        onSubmitted: (value) {
                          _todoFocus.requestFocus();
                          setState(() {});

                          if (value != '') {
                            if (_taskId != 0) {
                              _dbhelper.updatetaskDescription(_taskId, value);
                              setState(() {
                                _taskDescription = value;
                              });
                            }
                          }
                        },
                        focusNode: _descriptionFocus,
                        decoration: InputDecoration(
                          hintText: "Enter Same Descreption for Your Task",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isvisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbhelper.getTodo(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: GestureDetector(
                                  onTap: () async {
                                    // todo : change the isDone state
                                    if (snapshot.data[index].isDone == 0) {
                                      await _dbhelper.updateisDone(
                                          snapshot.data[index].id, 1);
                                      setState(() {});
                                    } else {
                                      await _dbhelper.updateisDone(
                                          snapshot.data[index].id, 0);
                                      setState(() {});
                                    }
                                  },
                                  child: Todowidget(
                                    isDone: snapshot.data[index].isDone == 0
                                        ? false
                                        : true,
                                    text: snapshot.data[index].title,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _isvisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right: 12,
                            ),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Color(0xFF211551),
                                width: 1.75,
                              ),
                            ),
                            child: Image(
                                image:
                                    AssetImage("assets/images/check_icon.png")),
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController()..text = '',
                              focusNode: _todoFocus,
                              onSubmitted: (value) async {
                                if (value != '') {
                                  //Check if the task is null
                                  if (_taskId != 0) {
                                    // ? add field to sqlite data base
                                    DatabaseHelper _dbhelper = DatabaseHelper();
                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    await _dbhelper.insertTodo(_newTodo);

                                    setState(() {
                                      _todoFocus.requestFocus();
                                    });
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter your todoo",
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _isvisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: InkWell(
                    splashColor: Colors.yellow,
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbhelper.deletetask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                            // color: Color(0xFF734911),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.red, Colors.red[200]],
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Image(
                            image:
                                AssetImage("assets/images/delete_icon.png"))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
