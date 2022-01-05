import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/todo_list.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/todo_cubit/todo_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/widgets/item_create_widget.dart';

class EventTodoWidget extends StatelessWidget {
  final Todo? todo;
  final Event event;

  const EventTodoWidget({Key? key, required this.todo, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TodoCubit(event: event),
        child: BlocBuilder<TodoCubit, TodoState>(builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TodoName: ${todo!.name.getOrCrash()}'),
              IconButton(
                  onPressed: () => showOverlay(context),
                  icon: const Icon(Icons.add)),

              /// Used as space
              const SizedBox(height: 20),

              TodoList(todo: todo!, event: event),
            ],
          );
        }));
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
    overlayEntry = OverlayEntry(builder: (buildContext) {
      return ItemCreateWidget(
          overlayEntry: overlayEntry!, event: event, todo: todo!);
    });
    overlayState.insert(overlayEntry);
  }
}
