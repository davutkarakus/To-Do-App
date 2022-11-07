import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_flutter1/constans/colors.dart';
import 'package:todo_flutter1/data/dbHelper.dart';

import '../models/todo.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({Key? key}) : super(key: key);

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  var txtName = TextEditingController();

  List<todo>? todos;
  List<todo>? dene;
  int todosCount = 0;

  DbHelper dbHelper = new DbHelper();

  @override
  void initState() {
    getTodos();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildSearchField(),
            _buildTodoList(),
            ToDoItem(),
            _buildNewTodo(),
          ],
        ),
      ),
    );
  }

  _buildNewTodo() {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 0)
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: txtName,
                  decoration: InputDecoration(
                      hintText: "Add a new todo item",
                      border: InputBorder.none),
                ),
              )),
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.blue),
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                if (txtName.text != "") {
                  addTodos();
                  txtName.clear();

                  FocusScope.of(context).unfocus();

                  setState(() {});
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _buildTodoList() {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 30),
      alignment: Alignment.centerLeft,
      child: const Text(
        "All ToDos",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        textAlign: TextAlign.start,
      ),
    );
  }

  ToDoItem() {
    return Expanded(
      child: ListView.builder(
        itemCount: todosCount,
        itemBuilder: (BuildContext context, int position) {
          print(position);
          return Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onTap: () {
                print("On Clicked list item.");
              },
              tileColor: Colors.white,
              leading: Checkbox(
                value: (todos![position].checked),
                onChanged: (value) {
                  setState(() => todos![position].checked = value!);

                  dbHelper.update(todo.withId(
                      todoText: todos![position].todoText,
                      id: todos![position].id,
                      checked: todos![position].checked));
                },
                activeColor: tdBlue,
              ),
              title: Text(
                todos![position].todoText.toString(),
                style: TextStyle(
                  color: tdBlack,
                  fontSize: 16,
                  decoration: todos![position].checked!
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              trailing: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: tdRed, borderRadius: BorderRadius.circular(5)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () {
                      print(todos![position].id);
                      dbHelper.delete(todos![position].id!);
                      setState(() {
                        getTodos();
                      });
                    },
                  )),
            ),
          );
        },
      ),
    );
  }

  Container _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        decoration: const InputDecoration(
            labelText: "Search",
            icon: Icon(Icons.search, color: tdBlack, size: 25),
            border: InputBorder.none),
        onChanged: searchBook,
      ),

    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: tdBGColor,
      leadingWidth: 80,
      leading: SvgPicture.asset(
        'assets/menu.svg',
        width: 10,
        height: 10,
        color: tdBlack,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2018/06/27/07/45/student-3500990_960_720.jpg"),
          ),
        )
      ],
    );
  }

  void getTodos() async {
    var todosFuture = dbHelper.getTodos();
    todosFuture.then((value) {
      setState(() {
        todos = value;
        todosCount = value.length;
        dene=todos;
      });
    });
  }

  void addTodos() async {
    await dbHelper.insert(todo(todoText: txtName.text, checked: false));
    setState(() {});
    getTodos();
  }

  void searchBook(String value) {
    List<todo>? results = [];


    if (value.isEmpty) {
      getTodos();
    } else  {
      setState(() {
        if(dene!=null) {
          results = dene?.where((element) =>
              element.todoText.toString().toLowerCase().contains(
                  value.toLowerCase())).toList();
          todos = results;
          todosCount = results!.length;
        }
      });

    }


  }

}