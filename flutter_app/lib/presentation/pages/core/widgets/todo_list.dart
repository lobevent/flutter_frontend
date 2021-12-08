import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/todo_cubit/todo_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:provider/src/provider.dart';
import 'package:auto_route/auto_route.dart';

import '../../event/todos/widgets/item_element_widget.dart';

class TodoList extends StatelessWidget {
  final Event event;
  final Todo? todo;
  const TodoList({Key? key, required this.todo, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TodoItemList(todo!.items, context);
  }

  Widget TodoItemList(List<Item> items, BuildContext context) {
    return Column(
      children: <Widget>[...getTodoItems(items, context)],
    );
  }

  List<Widget> getTodoItems(List<Item> items, BuildContext context) {
    final List<Widget> itemElements = [];

    items.forEach((element) {
      final Widget elements = ItemElementWidget(
        item: element,
        name: element.name.getOrCrash(),
        profiles: element.profiles!,
        description: element.description.getOrCrash(),

        ///for function passing for the buttons
        deleteItemFunc: (Item item) {
          context.read<TodoCubit>().deleteItem(todo!, item);
        },
        //edit items, pass the item
        editItemFunc: (Item item) {
          context.router.push(ItemCreateWidgetRoute(
              event: event,
              todo: todo!,
              item: item,
              onEdit: (Item item) {
                context.read<TodoCubit>().editItem(todo!, item);
              }));

          //context.read<TodoCubit>().editItem(todo!, item);
        },
      );
      itemElements.add(elements);
    });
    return itemElements;
  }
}
