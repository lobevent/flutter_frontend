import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/event_todo_widget.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
        builder: (context, state) {
      return state.maybeMap(
        loaded: (state) {
          //check if todoList existed; else create one
          if (state.event.todo != null) {
            return EventTodoWidget(todo: state.event.todo!, event: state.event);
          } else
          //build without a toddo there if its not public
          if (!state.event.public) {
            return IconButton(
                onPressed: () => context.router
                    .push(ItemCreateWidgetRoute(event: state.event)),
                icon: Icon(Icons.add_circle));
          }
          return Text('');
        },
        orElse: () {
          return const Text('');
        },
      );
    });
  }
}
