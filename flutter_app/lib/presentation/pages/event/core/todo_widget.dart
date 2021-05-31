import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;

  const TodoWidget({required ObjectKey key, required this.todo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TodoWidgetState();
}

class TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
