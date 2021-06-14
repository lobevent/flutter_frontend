import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/application/todo/todo_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/widgets/todo_content.dart';

class EventTodoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(event: Event.empty()), //TODO Event
        child: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state is LoadInProgress,
                child: state.maybeMap(
                    error: (failure) => ErrorMessage(errorText: failure.toString(),),
                    orElse: () => ContentContainer()),
            );
            },
        ),
    );
  }

  Widget ContentContainer(){
    return const Scaffold(
        body: ColorfulSafeArea(
          color: Colors.yellow,
          child: SingleChildScrollView(
            child: TodoContent(),
          ),
        ),
    );
  }
}
