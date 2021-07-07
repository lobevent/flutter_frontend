import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/widgets/item_create_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/widgets/item_element_widget.dart';

class EventTodoWidget extends StatelessWidget {
  final Todo? todo;

  const EventTodoWidget({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('TodoName: ${todo!.name.getOrCrash()}'),
        IconButton(onPressed: () => context.router.push(ItemCreateWidgetRoute()), icon: Icon(Icons.add)),

        /// Used as space
        const SizedBox(height: 20),

        TodoItemList(todo!.items),
      ],
    );
  }

  Widget TodoItemList (List<Item> items){
    return Column(
      children: <Widget> [
        ...getTodoItems(items)
      ],
    );
  }

  List<Widget> getTodoItems(List<Item> items){
    final List<Widget> itemElements = [];

    items.forEach((element) {
      final Widget elements = ItemElementWidget(
        name: element.name.getOrCrash(),
        profiles: element.profiles,
        description: element.description.getOrCrash(),
      );
      itemElements.add(elements);
    });
    return itemElements;
  }
}
