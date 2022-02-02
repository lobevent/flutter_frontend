import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/Overlays/todolist_form.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/EventTodoWidget/event_todo_widget.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class TodoWidget extends StatefulWidget {
  const TodoWidget({Key? key}) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  late Event eventPass;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(builder: (context, state) {
      return state.maybeMap(
        loaded: (stateLoaded) {
          eventPass = stateLoaded.event;
          //check if todoList existed; else show button to create one
          if (stateLoaded.event.todo != null) {
            return EventTodoWidget(todo: stateLoaded.event.todo, event: stateLoaded.event, showLoading: stateLoaded.addingItem,);
          }
          else {
            // create todolist button
            return IconButton(
                onPressed: () {
                  showCreateTodoListOverlay(context);
                },
                icon: const Icon(Icons.public));
          }
        },
        orElse: () {
          return const Text('');
        },
      );
    });
  }

  //overlay for orgalist creation
  //we name it buildContext cause we need the cubit context also for sending orgalist to server
  void showCreateTodoListOverlay(BuildContext buildContext) async {
    //initialise overlaystate and entries
    final OverlayState overlayState = Overlay.of(buildContext)!;
    //have to do it nullable
    OverlayEntry? overlayEntry;

    //controllers for name and desc


    //this is the way to work with overlays
    overlayEntry = OverlayEntry(builder: (buildContext)
    {
      return TodoListForm(overlayEntry: overlayEntry!, cubitContext: context, event: eventPass,);
    });
    //insert the entry in the state to make it accesible
    overlayState.insert(overlayEntry);
  }

  @override
  void initState() {
    super.initState();
  }
}
