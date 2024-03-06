// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_todo/components/dialogbox.dart';
import 'package:flutter_todo/components/todotiles.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box("mybox");

  TodoDB db = TodoDB();
  // List db.todos = [
  //   ["WAH! WAH! WAH! WA-", false],
  //   ["Eat cookies!", false],
  //   ["TAKOTIME!", false],
  // ];

  @override
  void initState() {
    // TODO: implement initState
    if (_myBox.get("todolist") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todos[index][1] = !db.todos[index][1];
    });
    db.updateData();
  }

  void saveNewTask() {
    setState(() {
      db.todos.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateData();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      db.todos.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        title: Center(
          child: Text(
            "TAKO DO!",
            style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: createNewTask,
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: db.todos.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskname: db.todos[index][0],
            taskCompleted: db.todos[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
