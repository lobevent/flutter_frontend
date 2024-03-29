import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Todos/item_element_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/todo_overlay_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/EventTodoWidget/es_ec_td_todo_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/EventTodoWidget/es_ec_td_tw_todo_overview.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:provider/src/provider.dart';
import 'package:auto_route/auto_route.dart';

import '../../../../../domain/profile/profile.dart';
import '../../../../../l10n/app_strings.dart';
import '../gen_dialog.dart';

///
/// List of tdo items, used in [EventTodoWidget]
///
class TodoList extends StatefulWidget {
  final Event event;
  final Todo? todo;
  final bool showLoading;
  const TodoList(
      {Key? key,
      required this.todo,
      required this.event,
      this.showLoading = false})
      : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return TodoItemList(widget.todo!.items, context);
  }

  Widget TodoItemList(List<Item> items, BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[...getTodoItems(items, context)],
        ),
      ),
    );
  }

  List<Widget> getTodoItems(List<Item> items, BuildContext context) {
    final List<Widget> itemElements = [];

    // show loading animation on request still out
    if (widget.showLoading) {
      itemElements.add(const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Center(
            child: Align(
              alignment: Alignment.center,
              child: SpinKitRotatingCircle(
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          )));
    }

    items.forEach((element) {
      final Widget elements = ItemElementWidget(
        item: element,
        name: element.name.getOrCrash(),
        profiles: element.profiles!,
        description: element.description.getOrCrash(),
        event: widget.event,

        ///for function passing for the buttons
        deleteItemFunc: (Item item) {
          GenDialog.genericDialog(
                  context,
                  AppStrings.deleteCommentDialogAbort,
                  AppStrings.deleteCommentDialogText,
                  AppStrings.deleteCommentDialogConfirm,
                  AppStrings.deleteCommentDialogAbort)
              .then((value) async => {
                    if (value)
                      context
                          .read<EventScreenCubit>()
                          .deleteItem(widget.todo!, item)
                    else
                      print("abort delete todo item"),
                  });
        },
        //edit items, pass the item
        editItemFunc: (Item item) {},
        assignProf: (Item item, Profile? profile) {
          //add support for adding other profiles and not only the own maybe
          context
              .read<EventScreenCubit>()
              .assignProfile(item, profile != null ? profile : null);
        },
        deassignProf: (Item item, Profile? profile) {
          //add support for deadding other profiles and not only the own maybe
          context
              .read<EventScreenCubit>()
              .deassignProfile(item, profile != null ? profile : null);
        },
      );
      itemElements.add(elements);
    });

    return itemElements;
  }
}
