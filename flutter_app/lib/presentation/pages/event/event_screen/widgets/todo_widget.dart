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
import 'package:flutter_frontend/presentation/pages/event/todos/widgets/item_create_widget.dart';
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
            return EventTodoWidget(todo: state.event.todo, event: state.event);
          }
          if (state.event.todo == null) {
            return IconButton(
                onPressed: () => context
                    .read<EventScreenCubit>()
                    .createOrgaEvent(state.event),
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
}
