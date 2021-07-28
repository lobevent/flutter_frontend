import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/event_todo_widget.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({Key? key}) : super(key: key);

  Widget buildWithoutTodo() {
    return IconButton(onPressed: null, icon: Icon(Icons.add_circle));
  }

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
            return buildWithoutTodo();
        },
        orElse: () {
          return const Text('');
        },
      );
    });
  }
}
