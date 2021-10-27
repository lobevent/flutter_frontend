import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/todo_list.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventTodoWidget extends StatelessWidget {
  final Todo? todo;
  final Event event;

  const EventTodoWidget({Key? key, required this.todo, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('TodoName: ${todo!.name.getOrCrash()}'),
        IconButton(
            onPressed: () =>
                context.router.push(ItemCreateWidgetRoute(event: event)),
            icon: const Icon(Icons.add)),

        /// Used as space
        const SizedBox(height: 20),

        TodoList(todo: todo),
      ],
    );
  }
}
