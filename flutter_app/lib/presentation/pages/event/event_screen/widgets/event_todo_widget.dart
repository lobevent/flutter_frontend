import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Todos/todo_list.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/todo_cubit/todo_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import 'Overlays/item_create_widget.dart';

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
                  onPressed: () => /*context.read<EventScreenCubit>().postItem(itemName: 'abc', itemDescription: 'itemDescription', todo: todo!),*/showOverlay(context),
                  icon: const Icon(Icons.add)),

              /// Used as space
              const SizedBox(height: 20),

              TodoList(todo: todo!, event: event),
            ],
          );
  }

  void showOverlay(BuildContext buildContext) async {
    //initialise overlaystate and entries
    final OverlayState overlayState = Overlay.of(buildContext)!;
    //have to do it nullable
    OverlayEntry? overlayEntry;

    //controllers for name and desc
    final orgaNameController = TextEditingController();
    final orgaDescriptionController = TextEditingController();

    //this is the way to work with overlays
    overlayEntry = OverlayEntry(builder: (context) {
      return ItemCreateWidget(overlayEntry: overlayEntry!, event: event, todo: todo!, cubitContext: buildContext);
    });
    overlayState.insert(overlayEntry);
  }
}
