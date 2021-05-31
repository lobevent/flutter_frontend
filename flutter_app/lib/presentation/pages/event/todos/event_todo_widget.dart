import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/todo/todo_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';

class EventTodoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(event: Event.empty()),
      child: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          return state.maybeMap(
              loaded: (state) => Text(state.todo.name.getOrCrash()),
              orElse: () => Text("error"));
        },
      ),
    );
  }
}
