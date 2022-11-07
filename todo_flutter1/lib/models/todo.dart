import 'package:flutter/material.dart';

class todo {
  int? id;
  String? todoText;
  bool? checked;
  todo({this.todoText, this.checked});
  todo.withId({this.id, this.checked, this.todoText});
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["todoText"] = todoText;
    map["checked"] = ((checked!) ? 1 : 0);
    print(map["checked"]);
    return map;
  }

  todo.fromObject(dynamic o) {
    id = o["id"];
    todoText = o["todoText"];
    checked = ((o["checked"] == 1) ? true : false);
    print(checked);
  }

  // todo.withoutInfo() {}
  /* static List<todo> todoList() {
    return [
      todo(id: 1, todoText: "Morning Excercise", checked: false),
      todo(id: 2, todoText: "Morning Excercise2", checked: false),
      todo(id: 3, todoText: "Morning Excercise3", checked: false),
      todo(id: 4, todoText: "Morning Excercise4", checked: false),
      todo(id: 5, todoText: "Morning Excercise5", checked: false),
      todo(id: 6, todoText: "Morning Excercise6", checked: false),
    ];
  }*/
}
