import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';

import '../../event/todos/widgets/item_element_widget.dart';

class TodoList extends StatelessWidget {
  final Todo? todo;
  const TodoList({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TodoItemList(todo!.items);
  }

  Widget TodoItemList(List<Item> items) {
    return Column(
      children: <Widget>[...getTodoItems(items)],
    );
  }

  List<Widget> getTodoItems(List<Item> items) {
    final List<Widget> itemElements = [];

    items.forEach((element) {
      final Widget elements = ItemElementWidget(
        name: element.name.getOrCrash(),
        profiles: element.profiles!,
        description: element.description.getOrCrash(),
      );
      itemElements.add(elements);
    });
    return itemElements;
  }
}