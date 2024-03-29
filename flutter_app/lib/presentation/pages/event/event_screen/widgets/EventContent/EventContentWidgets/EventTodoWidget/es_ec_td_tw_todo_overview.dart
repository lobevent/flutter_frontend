import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Todos/todo_list.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/todo_overlay_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import '../../../Overlays/es_ol_item_create_form.dart';

class EventTodoWidget extends StatefulWidget {
  final Todo? todo;
  final Event event;
  final bool showLoading;
  const EventTodoWidget({Key? key, required this.todo, required this.event, this.showLoading = false})
      : super(key: key);

  @override
  State<EventTodoWidget> createState() => _EventTodoWidgetState();
}

class _EventTodoWidgetState extends State<EventTodoWidget> {
  @override
  Widget build(BuildContext context) {

          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TodoName: ${widget.todo!.name.getOrCrash()}'),
              // the create item button, for showing overlay
              if(widget.event.isHost)
                IconButton(
                    onPressed: () => showOverlay(context),
                    icon: const Icon(Icons.add)),
              /// Used as space
              const SizedBox(height: 20),

              TodoList(todo: widget.todo!, event: widget.event, showLoading: widget.showLoading,),
            ],
          );
  }

  void showOverlay(BuildContext buildContext) async {
    //initialise overlaystate and entries
    final OverlayState overlayState = Overlay.of(buildContext)!;

    //have to do it nullable
    OverlayEntry? overlayEntry;

    //this is the way to work with overlays
    overlayEntry = OverlayEntry(builder: (context) {
      return ItemCreateWidget(overlayEntry: overlayEntry!, todo: widget.todo!, cubitContext: buildContext);
    });
    overlayState.insert(overlayEntry);
  }
}
