import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/widgets/item_element_widget.dart';

class EventTodoWidget extends StatelessWidget {
  final Todo todo;

  const EventTodoWidget({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(todo.name.getOrCrash()),

        /// Used as space
        const SizedBox(height: 20),

        TodoItemList(todo.items),
      ],
    );
  }

  Widget TodoItemList (List<Item> items){
    return ListView(
      children: <Widget> [
        ...getTodoItems(items)
      ],
    );
  }

  List<Widget> getTodoItems(List<Item> items){
    final List<Widget> itemElements = [];

    items.forEach((element) {
      final Widget elements = ItemElementWidget(
        name: element.name.toString(),
        profiles: element.profiles,
        description: element.description.toString(),
      );
      itemElements.add(elements);
    });
    return itemElements;
  }
}
