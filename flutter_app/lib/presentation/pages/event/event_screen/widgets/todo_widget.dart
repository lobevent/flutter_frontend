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
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/event_todo_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/todo_cubit/todo_cubit.dart';
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
    return BlocBuilder<EventScreenCubit, EventScreenState>(
        builder: (context, state) {
      return state.maybeMap(
        loaded: (state) {
          eventPass = state.event;
          //check if todoList existed; else create one
          if (state.event.todo != null) {
            return EventTodoWidget(todo: state.event.todo, event: state.event);
          }
          if (state.event.todo == null) {
            return IconButton(
                /*onPressed: () => context
                    .read<EventScreenCubit>()
                    .createOrgaEvent(state.event),

                 */
                onPressed: () {
                  showOverlay(context);
                },
                icon: const Icon(Icons.public));
          } else
            return Text('');
        },
        orElse: () {
          return const Text('');
        },
      );
    });
  }

  //overlay for orgalist creation
  //we name it buildContext cause we need the cubit context also for sending orgalist to server
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
      return Scaffold(
          body: Column(
        children: [
          Text('Create Orgalist'),
          const SizedBox(height: 20),
          const Text('Organame:'),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Enter the Organame'),
            controller: orgaNameController,
          ),
          const SizedBox(height: 40),
          const Text('OrgaList Description:'),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Enter the Orgadescription'),
            controller: orgaDescriptionController,
          ),
          IconButton(
              onPressed: () {
                //check for overlay so it is nullsafe
                if (overlayEntry != null) {
                  //remove overlay so we have to dont fuck around with routes
                  overlayEntry.remove();
                }
                //create the orgalist and pass the event + inputted orgalistname +desc
                context.read<EventScreenCubit>().createOrgaEvent(eventPass,
                    orgaNameController.text, orgaDescriptionController.text);
              },
              icon: Icon(Icons.add))
        ],
      ));
    });
    //insert the entry in the state to make it accesible
    overlayState.insert(overlayEntry);
  }

  @override
  void initState() {
    super.initState();
  }
}
