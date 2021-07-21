import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/event_todo_widget.dart';

class TodoWidget extends StatelessWidget {
  final UniqueId eventId;
  const TodoWidget({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
        builder: (context, state) {
          return state.maybeMap(
              loaded: (state) {
                return EventTodoWidget(todo: state.event.todo!, eventId: eventId);
              },
              orElse: () {
                return const Text('');
              },
          );
        }
    );
  }
}
