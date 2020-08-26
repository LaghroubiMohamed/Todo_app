import 'dart:ffi';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Models/task.dart';
import 'package:todo_app/Models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todoapp.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        //create Table for the Tasks on the HomePage
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");

        //Create table for the todo list on the TaskPage
        await db.execute(
            "CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER,title TEXT, isDone INTEGER)");

        return db;
      },
      version: 1,
    );
  }

  //insert data for tasks
  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();

    await _db
        .insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

//update the task title
  Future<void> updatetasktitle(int id, String title) async {
    Database _db = await database();

    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

//Update the task description
  Future<void> updatetaskDescription(int id, String description) async {
    Database _db = await database();

    await _db.rawUpdate(
        "UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  //update the todos state isDone from false to true
  Future<void> updateisDone(int id, int isDone) async {
    Database _db = await database();

    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  //insert data for Todos
  // ignore: missing_return
  Future<Void> insertTodo(Todo todo) async {
    Database _db = await database();

    await _db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //get tasks for the list view in the HomePage
  Future<List<Task>> getTasks() async {
    // Get a reference to the database.
    Database _db = await database();

    // Query the table for all The Tasks.
    final List<Map<String, dynamic>> taskMap = await _db.query('tasks');

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return List.generate(taskMap.length, (i) {
      return Task(
        id: taskMap[i]['id'],
        title: taskMap[i]['title'],
        description: taskMap[i]['description'],
      );
    });
  }

  //get todo list for the tasks on the TaskPage
  Future<List<Todo>> getTodo(int taskId) async {
    // Get a reference to the database.
    Database _db = await database();

    // Query the table for all The Tasks.
    final List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId ");

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return List.generate(todoMap.length, (i) {
      return Todo(
        id: todoMap[i]['id'],
        title: todoMap[i]['title'],
        isDone: todoMap[i]['isDone'],
        taskId: todoMap[i]['taskId'],
      );
    });
  }

  Future<void> deletetask(int id) async {
    // Get a reference to the database.
    Database _db = await database();

    // Remove the Dog from the Database.
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }
}
