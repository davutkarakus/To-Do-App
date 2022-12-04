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

  
 
}
