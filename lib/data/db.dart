import 'package:hive_flutter/hive_flutter.dart';

class TodoDB {
  List todos = [];
  final _myBox = Hive.box("mybox");

  void createInitialData() {
    todos = [
      ["WAH! WAH! WAH! WA-", false],
      ["Eat cookies!", false],
      ["TAKOTIME!", false],
    ];
  }

  void loadData() {
    todos = _myBox.get("todolist");
  }

  void updateData() {
    _myBox.put("todolist", todos);
  }
}
